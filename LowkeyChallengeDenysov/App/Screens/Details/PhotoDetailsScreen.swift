//
//  PhotoDetailsScreen.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 05.07.2024.
//

import SwiftUI

struct PhotoDetailsScreen: View {
    
    private let imageLoader = UtilsFactory.imageLoader
    private let thumbnailURL: URL
    
    @State private var viewModel: PhotoDetailsViewModel
    
    init(id: Int, thumbnailURL: URL) {
        self.thumbnailURL = thumbnailURL
        _viewModel = State(wrappedValue: ViewModelFactory.detailsViewModel(forPhotoId: id))
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            CustomAsyncImage(url: viewModel.url) { phase in
                switch phase {
                case .fetching, .error:
                    ZStack {
                        if let image = imageLoader.cachedImage(at: thumbnailURL) {
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
        .task {
            await viewModel.fetchPhoto()
        }
    }
}
