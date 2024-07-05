//
//  LowkeyChallengeDenysovApp.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 30.06.2024.
//

import SwiftUI

@main
struct LowkeyChallengeDenysovApp: App {
    
    @State private var router = Router()
    
    init() {
        _ = UtilsFactory.networkReachabilityMonitor
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                PhotosListScreen().withRouter()
            }
            .environment(router)
        }
    }
}
