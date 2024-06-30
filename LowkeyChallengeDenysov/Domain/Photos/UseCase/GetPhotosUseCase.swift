//
//  GetPhotosUseCase.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

protocol GetPhotosUseCase {
    func invoke(page: Int, perPage: Int) async throws -> [Photo]
}

final class GetPhotosUseCaseImpl: GetPhotosUseCase {
    
    private let repository: PhotosRepository
    
    init(repository: PhotosRepository) {
        self.repository = repository
    }
    
    func invoke(page: Int, perPage: Int) async throws -> [Photo] {
        try await repository.photos(page: page, perPage: perPage)
    }
}
