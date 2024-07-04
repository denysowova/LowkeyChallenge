//
//  GetIsOnlineUseCase.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 04.07.2024.
//

import Foundation

protocol GetIsOnlineUseCase {
    func invoke() -> Bool
}

final class GetIsOnlineUseCaseImpl: GetIsOnlineUseCase {
    
    private let monitor: NetworkReachabilityMonitor
    
    init(networkReachabilityMonitor: NetworkReachabilityMonitor) {
        monitor = networkReachabilityMonitor
    }
    
    func invoke() -> Bool {
        monitor.isOnline()
    }
}
