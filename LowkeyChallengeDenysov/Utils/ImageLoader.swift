//
//  ImageLoader.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 3.07.24.
//

import UIKit

protocol ImageLoader {
    func image(at url: URL) async throws -> UIImage
}

final class ImageLoaderImpl: ImageLoader {
    
    enum Error: Swift.Error {
        case request(Swift.Error)
        case imageDecoding
    }
    
    static let shared = ImageLoaderImpl()
    
    private let session: URLSession = {
        let memoryCapacity = 500 * 1024 * 1024  /// 500 MB
        let diskCapacity = 1 * 1024 * 1024 * 1024  /// 1 GB
        let directory = URL.documentsDirectory.appending(path: "images")
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, directory: directory)
        
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = cache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    func image(at url: URL) async throws -> UIImage {
//        let request = URLRequest(url: url)
//
//        if let data = URLCache.shared.cachedResponse(for: request)?.data,
//           let image = UIImage(data: data) {
//            return image
//        } else {
//            return try await fetch(at: url)
//        }
        
        return try await fetch(at: url)
    }
    
    private func fetch(at url: URL) async throws -> UIImage {
        print("fetching at: \(url.absoluteString)")
        let request = URLRequest(url: url)
        let response: (data: Data, raw: URLResponse)
        
        do {
            response = try await session.data(from: url)
        } catch {
            throw Error.request(error)
        }
        
//        let cachedData = CachedURLResponse(response: response.raw, data: response.data)
//        URLCache.shared.storeCachedResponse(cachedData, for: request)
        
        // use the uikit thing for preparing the image?
        if let image = UIImage(data: response.data) {
            return image
        } else {
            throw Error.imageDecoding
        }
    }
}