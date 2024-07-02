//
//  PhotosListScreen.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import SwiftUI

enum PhotosListScreenState {
    case idle
    case loadingNextPage
}

struct PhotosListScreen: View {
    
    @State private var viewModel = ViewModelFactory.photosList()
    
    var body: some View {
        List {
            ForEach(viewModel.photos) { item in
                photoRowView(for: item)
            }
            
            switch viewModel.state {
            case .idle:
                ProgressView()
                    .progressViewStyle(.circular)
                    .onAppear {
                        viewModel.fetchPhotos()
                    }
            case .loadingNextPage:
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .listStyle(.plain)
        .task {
            viewModel.fetchPhotos()
        }
    }
    
    private func photoRowView(for item: PhotoListItem) -> some View {
        ZStack {
            AsyncImage(url: item.url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 150)
            
            VStack {
                Spacer()
                
                Text(String(item.id))
            }
//            .background {
//                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
//            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 6) // doesn't do anythinhg. width is calculated based on height and scaled to fill?
        .listRowSeparator(.hidden)
    }
}
