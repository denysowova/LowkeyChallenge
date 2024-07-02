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
                guard let thumbnailURL = URL(string: photo.src.small),
                      let url = URL(string: photo.src.large) else {
                    return nil
                }
                
                return Photo(
                    id: photo.id,
                    thumbnailURL: thumbnailURL,
                    url: url,
                    author: photo.photographer
                )
            }
        
//        return [
//            .init(
//                id: 1,
//                thumbnailURL: URL(string: "https://images.pexels.com/photos/1563356/pexels-photo-1563356.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
//                url: URL(string: "https://images.pexels.com/photos/1563356/pexels-photo-1563356.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
//                author: "Brad"
//            ),
//            .init(
//                id: 2,
//                thumbnailURL: URL(string: "https://images.pexels.com/photos/103123/pexels-photo-103123.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
//                url: URL(string: "https://images.pexels.com/photos/103123/pexels-photo-103123.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
//                author: "Steeve"
//            ),
//            .init(
//                id: 3,
//                thumbnailURL: URL(string: "https://images.pexels.com/photos/247851/pexels-photo-247851.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
//                url: URL(string: "https://images.pexels.com/photos/247851/pexels-photo-247851.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
//                author: "Samson"
//            )
//        ]
    }
}
