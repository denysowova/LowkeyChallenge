//
//  HTTPClientError.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

enum HTTPClientError<T: HTTPClientErrorResponse>: LocalizedError {
    case server(response: T)
    case request(raw: Error)
    case encoding(raw: Error)
    case decoding(raw: Error, data: Data)
    case constructingURL
    
    var response: T? {
        if case let .server(response) = self {
            return response
        } else {
            return nil
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .server(let response):
            "Server responded with an error: \(response.localizedDescription)"
        case .request(let raw):
            "Error performing a request: \(raw.localizedDescription)"
        case .encoding(let raw):
            "Error encoding request body: \(raw.localizedDescription)"
        case .decoding(let raw, let data):
            """
            Error decoding response body: \(raw.localizedDescription).\n
            Raw data: \(String(data: data, encoding: .utf8) ?? data.debugDescription)
            """
        case .constructingURL:
            "Error constructing a request URL"
        }
    }
}
