//
//  HTTPClientFactory.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

enum HTTPClientFactory {
    
    static let pexels: HTTPClient<PexelsErrorResponse> = {
        let memoryCapacity = 50 * 1024 * 1024  /// 50 MB
        let diskCapacity = 100 * 1024 * 1024  /// 100 MB
        let directory = URL.documentsDirectory.appending(path: "pexelsResponses")
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, directory: directory)
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        return HTTPClient<PexelsErrorResponse>(
            configuration: configuration,
            baseURL: URL(string: "https://api.pexels.com")!,
            headers: ["Authorization": "qOmjwqV8vcYsIwbSf8rOoAt397apPqDEtfa72KEC36UrYjIQiVxgPvQ1"]
        )
    }()
}
