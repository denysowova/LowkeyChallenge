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
    
    private var nextPage = 0
    
    private(set) var state: PhotosListScreenState = .loadingNextPage
    private(set) var photos: [PhotoListItem] = []
    
    init(getPhotosUseCase: GetPhotosUseCase) {
        self.getPhotosUseCase = getPhotosUseCase
    }
    
    func fetchPhotos() {
        Task {
            state = .loadingNextPage
            
            do {
                print("xxx fetching page \(nextPage)")
                // if next page is nil, do not show footer
                let fetchedPhotos = try await getPhotosUseCase.invoke(page: nextPage, perPage: 20)
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
