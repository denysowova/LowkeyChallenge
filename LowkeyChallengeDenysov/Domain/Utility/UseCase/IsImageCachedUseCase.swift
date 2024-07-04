//
//  IsImageCachedUseCase.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 04.07.2024.
//

import Foundation

protocol IsImageCachedUseCase {
    func invoke(for url: URL) -> Bool
}

final class IsImageCachedUseCaseImpl: IsImageCachedUseCase {
    
    private let imageLoader: ImageLoader
    
    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
    }
    
    func invoke(for url: URL) -> Bool {
        imageLoader.isImageCached(for: url)
    }
}
