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
    
    private(set) var photos: [PhotoListItem] = []
    
    init(getPhotosUseCase: GetPhotosUseCase) {
        self.getPhotosUseCase = getPhotosUseCase
    }
    
    func performTasks() {
        Task {
            do {
                photos = try await getPhotosUseCase.invoke(page: 0, perPage: 5)
                    .map {
                        PhotoListItem(id: $0.id, url: $0.url, author: $0.author)
                    }
            } catch {
                print("Error fetching photos: \(error.localizedDescription)")
            }
        }
    }
}
