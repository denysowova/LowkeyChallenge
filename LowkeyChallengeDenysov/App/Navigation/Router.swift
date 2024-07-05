//
//  Router.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 05.07.2024.
//

import SwiftUI
import Observation

@Observable
final class Router {
    
    var path = NavigationPath()
    
    func push(_ route: Route) {
        path.append(route)
    }
}
