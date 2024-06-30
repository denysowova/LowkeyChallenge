//
//  UseCaseFactory.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

enum UseCaseFactory {
    
    static func getPhotos() -> GetPhotosUseCase {
        GetPhotosUseCaseImpl(repository: RepositoryFactory.photos)
    }
}
