//
//  IsOnlineUseCase.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 04.07.2024.
//

import Foundation

protocol IsOnlineUseCase {
    func invoke() -> Bool
}

final class IsOnlineUseCaseImpl: IsOnlineUseCase {
    
    private let monitor: NetworkReachabilityMonitor
    
    init(networkReachabilityMonitor: NetworkReachabilityMonitor) {
        monitor = networkReachabilityMonitor
    }
    
    func invoke() -> Bool {
        monitor.isOnline()
    }
}
