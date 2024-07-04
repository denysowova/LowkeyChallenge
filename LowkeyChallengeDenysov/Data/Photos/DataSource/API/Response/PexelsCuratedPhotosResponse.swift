//
//  PexelsCuratedPhotosResponse.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

struct PexelsCuratedPhotosResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case nextPage = "next_page"
        case photos
    }
    
    let page: Int
    let perPage: Int
    let nextPage: String?
    let photos: [PexelsPhotoResponse]
}
