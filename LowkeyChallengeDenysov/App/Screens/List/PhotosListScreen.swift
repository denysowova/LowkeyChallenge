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
    
    private let rowHeight = 150.0
    
    @Environment(Router.self) private var router
    @State private var viewModel = ViewModelFactory.photosList()
    
    var body: some View {
        List {
            listContent()
            footerView()
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.refresh()
        }
        .task {
            viewModel.fetchPhotos()
        }
    }
    
    private var progressView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    private func listContent() -> some View {
        ForEach(viewModel.photos) { item in
            CustomAsyncImage(url: item.thumbnailURL) { phase in
                switch phase {
                case .fetching, .error:
                    Color.gray
                        .overlay {
                            progressView
                        }
                case .fetched(let image):
                    rowView(for: item, image: image)
                }
            }
            .frame(height: rowHeight)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: .black.opacity(0.5), radius: 6, x: 0, y: 3)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .onTapGesture {
                router.push(.details(item.photo))
            }
        }
    }
    
    private func rowView(for item: PhotoListItem, image: Image) -> some View {
        image.resizable().scaledToFill()
            .frame(height: rowHeight)
            .overlay {
                VStack {
                    Spacer()
                    
                    Text("By: \(item.author)")
                        .foregroundStyle(Color.white)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .background {
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black]),
                        startPoint: .center,
                        endPoint: .bottom
                    )
                }
            }
    }
    
    private func footerView() -> some View {
        progressView
            .listRowSeparator(.hidden)
            .onAppear {
                switch viewModel.state {
                case .idle:
                    viewModel.fetchPhotos()
                case .loadingNextPage:
                    break
                }
            }
    }
}
