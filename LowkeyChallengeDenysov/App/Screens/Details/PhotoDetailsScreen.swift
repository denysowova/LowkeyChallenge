//
//  PhotoDetailsScreen.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 05.07.2024.
//

import SwiftUI

struct PhotoDetailsScreen: View {
    
    private let imageLoader = UtilsFactory.imageLoader
    let photo: Photo
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            CustomAsyncImage(url: photo.url) { phase in
                switch phase {
                case .fetching, .error:
                    ZStack {
                        if let image = imageLoader.cachedImage(at: photo.thumbnailURL) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        }
                        
                        ProgressView()
                    }
                case .fetched(let image):
                    image.resizable()
                        .scaledToFit()
                }
            }
        }
    }
}
