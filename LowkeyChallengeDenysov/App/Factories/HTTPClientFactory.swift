//
//  HTTPClientFactory.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

enum HTTPClientFactory {
    
    static let pexels = HTTPClient<PexelsErrorResponse>(
        baseURL: URL(string: "https://api.pexels.com")!,
        headers: ["Authorization": "qOmjwqV8vcYsIwbSf8rOoAt397apPqDEtfa72KEC36UrYjIQiVxgPvQ1"]
    )
}
