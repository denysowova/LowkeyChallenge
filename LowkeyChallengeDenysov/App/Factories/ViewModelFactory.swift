//
//  ViewModelFactory.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

enum ViewModelFactory {
    
    static func photosList() -> PhotosListViewModel {
        PhotosListViewModel(getPhotosUseCase: UseCaseFactory.getPhotos())
    }
}
