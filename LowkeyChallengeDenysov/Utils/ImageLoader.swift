//
//  ImageLoader.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 3.07.24.
//

import UIKit

protocol ImageLoader {
    func image(at url: URL) async throws -> UIImage
    func isImageCached(for url: URL) -> Bool
    func cachedImage(at url: URL) -> UIImage?
}

final class ImageLoaderImpl: ImageLoader {
    
    enum Error: Swift.Error {
        case request(Swift.Error)
        case imageDecoding
    }
    
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
        let response: (data: Data, raw: URLResponse)
        
        do {
            response = try await session.data(from: url)
        } catch {
            throw Error.request(error)
        }
        
        if let image = UIImage(data: response.data) {
            return image
        } else {
            throw Error.imageDecoding
        }
    }
    
    func isImageCached(for url: URL) -> Bool {
        let request = URLRequest(url: url)
        return session.configuration.urlCache?.cachedResponse(for: request) != nil
    }
    
    func cachedImage(at url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        
        guard let response = session.configuration.urlCache?.cachedResponse(for: request),
              let image = UIImage(data: response.data) else {
            return nil
        }
        
        return image
    }
}
