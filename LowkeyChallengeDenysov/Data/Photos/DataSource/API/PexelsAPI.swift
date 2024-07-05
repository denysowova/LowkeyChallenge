//
//  PexelsAPI.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

protocol PhotosDataSource {
    func photo(by id: Int) async throws -> PexelsPhotoResponse
    func curatedPhotos(page: Int, perPage: Int) async throws -> PexelsCuratedPhotosResponse
}

final class PexelsAPI: PhotosDataSource {
   
    private let client: HTTPClient<PexelsErrorResponse>
    
    init(client: HTTPClient<PexelsErrorResponse>) {
        self.client = client
    }
    
    func photo(by id: Int) async throws -> PexelsPhotoResponse {
        try await client.performRequest(
            "v1/photos/\(id)",
            method: .get
        )
    }
    
    func curatedPhotos(page: Int, perPage: Int) async throws -> PexelsCuratedPhotosResponse {
        let queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        return try await client.performRequest(
            "v1/curated",
            method: .get,
            queryItems: queryItems
        )
    }
}
