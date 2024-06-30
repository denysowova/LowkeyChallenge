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
//            .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/1563356/pexels-photo-1563356.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "Brad"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/103123/pexels-photo-103123.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "Steeve"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/247851/pexels-photo-247851.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "Samson"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "David"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/1066176/pexels-photo-1066176.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "Adam"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/1563356/pexels-photo-1563356.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "Brad"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/103123/pexels-photo-103123.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "Steeve"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/247851/pexels-photo-247851.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "Samson"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/1323550/pexels-photo-1323550.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "David"),
//            
//                .init(id: UUID().uuidString, url: URL(string: "https://images.pexels.com/photos/1066176/pexels-photo-1066176.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!, author: "Adam")
//        ]
    }
}
