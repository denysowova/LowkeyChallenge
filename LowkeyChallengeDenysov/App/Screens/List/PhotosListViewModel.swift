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
    private let isOnlineUseCase: IsOnlineUseCase
    private let isImageCachedUseCase: IsImageCachedUseCase
    
    private var nextPage = 0
    
    private(set) var state: PhotosListScreenState = .loadingNextPage
    private(set) var photos: [PhotoListItem] = []
    
    init(
        getPhotosUseCase: GetPhotosUseCase,
        isOnlineUseCase: IsOnlineUseCase,
        isImageCachedUseCase: IsImageCachedUseCase
    ) {
        self.getPhotosUseCase = getPhotosUseCase
        self.isOnlineUseCase = isOnlineUseCase
        self.isImageCachedUseCase = isImageCachedUseCase
    }
    
    func fetchPhotos() {
        Task {
            state = .loadingNextPage
            
            let isOnline = isOnlineUseCase.invoke()
            
            do {
                let fetchedPhotos = try await getPhotosUseCase.invoke(page: nextPage, perPage: 20)
                    .filter { photo in
                        let isDuplicate = photos.contains { $0.id == photo.id }
                        
                        guard !isDuplicate else {
                            return false
                        }
                        
                        return isOnline || isImageCachedUseCase.invoke(for: photo.thumbnailURL)
                    }
                    .map {
                        PhotoListItem(
                            id: $0.id,
                            thumbnailURL: $0.thumbnailURL,
                            url: $0.url,
                            authorText: "By: \($0.author)"
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
    
    func refresh() {
        photos = []
        nextPage = 0
        fetchPhotos()
    }
}
