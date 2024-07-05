//
//  CachedAsyncImage.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 3.07.24.
//

import SwiftUI

enum CachedAsyncImagePhase {
    case fetching
    case error(Error)
    case fetched(Image)
}

struct CachedAsyncImage<Content>: View where Content: View {
    
    enum Error: Swift.Error {
        case request(Swift.Error)
        case imageDecoding
    }
    
    private let imageLoader = UtilsFactory.imageLoader
    @State private var phase: CachedAsyncImagePhase = .fetching
    
    let url: URL?
    @ViewBuilder let content: (CachedAsyncImagePhase) -> Content
    
    var body: some View {
        content(phase)
            .task(id: url) {
                await fetchImage()
            }
    }
    
    private func fetchImage() async {
        guard let url else {
            return
        }
        
        do {
            let image = try await imageLoader.image(at: url)
            phase = .fetched(Image(uiImage: image))
        } catch {
            phase = .error(Error.request(error))
        }
    }
}
