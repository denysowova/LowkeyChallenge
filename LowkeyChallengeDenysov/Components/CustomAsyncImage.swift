//
//  CustomAsyncImage.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 3.07.24.
//

import SwiftUI
import UIKit

enum CustomAsyncImagePhase {
    case fetching
    case error(Error)
    case fetched(Image)
}

struct CustomAsyncImage<Content>: View where Content: View {
    
    enum Error: Swift.Error {
        case request(Swift.Error)
        case imageDecoding
    }
    
    @State private var phase: CustomAsyncImagePhase = .fetching
    
    let url: URL
    @ViewBuilder let content: (CustomAsyncImagePhase) -> Content
    
    var body: some View {
        content(phase)
            .task(id: url) {
                await fetchImage()
            }
    }
    
    private func fetchImage() async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // use the uikit thing for preparing the image?
            if let image = UIImage(data: data) {
                phase = .fetched(Image(uiImage: image))
            } else {
                phase = .error(Error.imageDecoding)
            }
        } catch {
            phase = .error(Error.request(error))
        }
    }
}
