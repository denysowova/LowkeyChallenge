//
//  PhotosListScreen.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import SwiftUI

struct PhotosListScreen: View {
    
    @State private var viewModel = ViewModelFactory.photosList()
    
    var body: some View {
        List(viewModel.photos) { item in
            Text("Author: \(item.author)")
        }
        .task {
            viewModel.performTasks()
        }
    }
}
