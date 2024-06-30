//
//  PhotosRepository.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

protocol PhotosRepository {
    func photos(page: Int, perPage: Int) async throws -> [Photo]
}

final class PhotosRepositoryImpl: PhotosRepository {
    
    private let dataSource: PhotosDataSource
    
    init(dataSource: PhotosDataSource) {
        self.dataSource = dataSource
    }
    
    func photos(page: Int, perPage: Int) async throws -> [Photo] {
        try await dataSource.curatedPhotos(page: page, perPage: perPage)
            .photos
            .compactMap { photo in
                guard let url = URL(string: photo.src.medium) else {
                    return nil
                }
                
                return Photo(id: photo.id, url: url, author: photo.photographer)
            }
    }
}
