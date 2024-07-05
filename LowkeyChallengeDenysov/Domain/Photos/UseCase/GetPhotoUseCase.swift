//
//  GetPhotoUseCase.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 05.07.2024.
//

import Foundation

protocol GetPhotoUseCase {
    func invoke(by id: Int) async throws -> Photo
}

final class GetPhotoUseCaseImpl: GetPhotoUseCase {
    
    private let repository: PhotosRepository
    
    init(repository: PhotosRepository) {
        self.repository = repository
    }
    
    func invoke(by id: Int) async throws -> Photo {
        try await repository.photo(by: id)
    }
}
