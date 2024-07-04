//
//  PhotosListViewModel.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation
import Observation

@Observable
final class PhotosListViewModel {
    
    private let getPhotosUseCase: GetPhotosUseCase
    private let getIsOnlineUseCase: GetIsOnlineUseCase
    
    private var nextPage = 0
    
    private(set) var state: PhotosListScreenState = .loadingNextPage
    private(set) var photos: [PhotoListItem] = []
    
    init(getPhotosUseCase: GetPhotosUseCase, getIsOnlineUseCase: GetIsOnlineUseCase) {
        self.getPhotosUseCase = getPhotosUseCase
        self.getIsOnlineUseCase = getIsOnlineUseCase
    }
    
    #warning("use thumbnail url here and in the list!!!")
    // 1. urlcache is paginated, you get cached responses based on url which are different only by the page query param
    // can inject the network reachability into the http client and set cache policy based on that
    // or implement own cache with user defaults.
    // 2. use case can return nextPage together with data. If offline, return nil for next page not to show footer
    // also use case can store last fetched page in user defaults and if offline, fetch N (last page fetched) times
    // the items and return them all together.
    // if using user defaults though, this won't be needed. In case of custom cache for responses
    // do not do HX style of giving cache and then network. Always try to get network first and if fails, return all cache
    // If network is success -> invalidate whole cache and store new responses
    func fetchPhotos() {
        Task {
            state = .loadingNextPage
            
            let isOnline = getIsOnlineUseCase.invoke()
            
            do {
                print("xxx fetching page \(nextPage)")
                // if next page is nil, do not show footer
                let fetchedPhotos = try await getPhotosUseCase.invoke(page: nextPage, perPage: 20)
                    .filter { photo in
                        let isDuplicate = photos.contains { $0.id == photo.id }
                        
                        guard !isDuplicate else {
                            return false
                        }
                        
                        return isOnline || ImageLoaderImpl.shared.isImageCached(for: photo.url)
                    }
                    .map {
                        PhotoListItem(
                            id: $0.id,
                            thumbnailURL: $0.thumbnailURL,
                            url: $0.url,
                            author: $0.author
                        )
                    }
                
                photos.append(contentsOf: fetchedPhotos)
                nextPage += 1
            } catch {
                print("Error fetching photos: \(error.localizedDescription)")
            }
            
            state = .idle
        }
    }
}
