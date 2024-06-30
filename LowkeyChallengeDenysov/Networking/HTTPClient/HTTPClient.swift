//
//  HTTPClient.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import Foundation

protocol HTTPClientRequestInterceptor {
    func adapt(_ request: URLRequest) async -> URLRequest
}

final class HTTPClient<ErrorResponse: HTTPClientErrorResponse> {
    
    private typealias ClientError = HTTPClientError<ErrorResponse>
    
    enum Method: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    private let session = URLSession(configuration: .default)
    private let baseURL: URL
    private let defaultHeaders: [String: String]
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let interceptors: [HTTPClientRequestInterceptor]
    
    init(
        baseURL: URL,
        headers: [String: String] = [:],
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder(),
        interceptors: [HTTPClientRequestInterceptor] = []
    ) {
        self.baseURL = baseURL
        self.defaultHeaders = headers
        self.encoder = encoder
        self.decoder = decoder
        self.interceptors = interceptors
    }
    
    // MARK: - Request creation
    
    private func constructURL(forPath urlPath: String?, withQuery queryItems: [URLQueryItem]) throws -> URL {
        var endpoint = baseURL
        
        if let urlPath {
            endpoint.append(path: urlPath)
        }
        
        guard !queryItems.isEmpty else {
            return endpoint
        }
        
        var urlComponents = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        
        if let queryEndpoint = urlComponents?.url(relativeTo: endpoint) {
            return queryEndpoint
        } else {
            throw ClientError.constructingURL
        }
    }
    
    private func createRequest(
        _ urlPath: String?,
        method: Method,
        headers: [String: String],
        body: Encodable?,
        queryItems: [URLQueryItem]
    ) throws -> URLRequest {
        
        let endpoint = try constructURL(forPath: urlPath, withQuery: queryItems)

        var request = URLRequest(url: endpoint)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        defaultHeaders
            .merging(headers) { (default, _) in `default` }
            .forEach { (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        
        guard let body else {
            return request
        }
        
        do {
            request.httpBody = try encoder.encode(body)
            return request
        } catch {
            throw ClientError.encoding(raw: error)
        }
    }
    
    private func runInterceptors(on request: URLRequest) async -> URLRequest {
        var resultRequest = request
        
        for interceptor in interceptors {
            resultRequest = await interceptor.adapt(resultRequest)
        }
        
        return resultRequest
    }
    
    // MARK: - Response parsing
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ClientError.decoding(raw: error, data: data)
        }
    }
    
    // MARK: - HTTP Request
    
    func performRequest<Response: Decodable>(
        _ urlPath: String? = nil,
        method: Method,
        headers: [String: String] = [:],
        body: Encodable? = nil,
        queryItems: [URLQueryItem] = []
    ) async throws -> Response {
        
        var request = try createRequest(
            urlPath,
            method: method,
            headers: headers,
            body: body,
            queryItems: queryItems
        )
        
        request = await runInterceptors(on: request)
        
        let response: (data: Data, raw: URLResponse)

        do {
            response = try await session.data(for: request)
        } catch {
            throw ClientError.request(raw: error)
        }
        
        let isSuccess = (response.raw as? HTTPURLResponse)?.statusCode == 200
        
        if isSuccess {
            return try decode(Response.self, from: response.data)
        } else {
            let errorResponse = try decode(ErrorResponse.self, from: response.data)
            throw ClientError.server(response: errorResponse)
        }
    }
}

