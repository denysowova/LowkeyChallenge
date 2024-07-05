//
//  PhotosRepository.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

enum PhotosRepositoryError: Error {
    case malformedResponse
}

protocol PhotosRepository {
    func photo(by id: Int) async throws -> Photo
    func photos(page: Int, perPage: Int) async throws -> [Photo]
}

final class PhotosRepositoryImpl: PhotosRepository {
    
    private let dataSource: PhotosDataSource
    
    init(dataSource: PhotosDataSource) {
        self.dataSource = dataSource
    }
    
    func photo(by id: Int) async throws -> Photo {
        if let photo = try await dataSource.photo(by: id).toEntity() {
            return photo
        } else {
            throw PhotosRepositoryError.malformedResponse
        }
    }
    
    func photos(page: Int, perPage: Int) async throws -> [Photo] {
        try await dataSource.curatedPhotos(page: page, perPage: perPage)
            .photos
            .compactMap { $0.toEntity() }
    }
}

private extension PexelsPhotoResponse {
    
    func toEntity() -> Photo? {
        guard let thumbnailURL = URL(string: src.medium),
              let url = URL(string: src.original) else {
            return nil
        }
        
        return Photo(
            id: id,
            thumbnailURL: thumbnailURL,
            url: url,
            author: photographer
        )
    }
}
