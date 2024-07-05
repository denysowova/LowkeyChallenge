//
//  View+WithRouter.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 05.07.2024.
//

import SwiftUI

private struct WithRouter: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .list:
                    PhotosListScreen()
                case .details(let photo):
                    PhotoDetailsScreen(photo: photo)
                }
            }
    }
}

extension View {
    
    func withRouter() -> some View {
        ModifiedContent(content: self, modifier: WithRouter())
    }
}
