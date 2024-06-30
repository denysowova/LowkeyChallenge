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
        HStack {
            AsyncImage(url: item.url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 50)
            
            Spacer()
            
            Text(String(item.id))
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.clear)
        }
        .listRowSeparator(.hidden)
    }
}
