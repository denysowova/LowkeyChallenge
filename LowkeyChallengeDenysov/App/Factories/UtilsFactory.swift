//
//  UtilsFactory.swift
//  LowkeyChallengeDenysov
//
//  Created by Volodymyr Denysov on 04.07.2024.
//

import Foundation

enum UtilsFactory {
    static let networkReachabilityMonitor: NetworkReachabilityMonitor = NetworkReachabilityMonitorImpl()
}
