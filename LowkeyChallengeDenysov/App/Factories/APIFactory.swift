//
//  APIFactory.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

enum APIFactory {
    static let pexels: PhotosDataSource = PexelsAPI(client: HTTPClientFactory.pexels)
}
