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
            listView()
            footerView()
        }
        .listStyle(.plain)
        .task {
            viewModel.fetchPhotos()
        }
    }
    
    private func listView() -> some View {
        ForEach(viewModel.photos) { item in
            ZStack {
                AsyncImage(url: item.url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    HStack {
                        Spacer()
                        
                        ProgressView()
                        
                        Spacer()
                    }
                }
                .frame(height: 150)
                .frame(maxWidth: .infinity)
                
                VStack {
                    Spacer()
                    
                    Text(String(item.id))
                        .foregroundStyle(Color.red)
                }
    //            .background {
    //                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
    //            }
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 3)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
    
    @ViewBuilder
    private func footerView() -> some View {
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
        }    }
}
