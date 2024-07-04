//
//  NetworkReachabilityMonitor.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 3.07.24.
//

import Foundation
import Network

protocol NetworkReachabilityMonitor {
    func isOnline() -> Bool
}

final class NetworkReachabilityMonitorImpl: NetworkReachabilityMonitor {
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.lowkey.networkReachabilityMonitor")
    
    static let shared =  NetworkReachabilityMonitorImpl()
    
    init() {
        monitor.start(queue: queue)
    }
    
    func isOnline() -> Bool {
        switch monitor.currentPath.status {
        case .satisfied:
            true
        case .unsatisfied, .requiresConnection:
            false
        @unknown default:
            true
        }
    }
}
