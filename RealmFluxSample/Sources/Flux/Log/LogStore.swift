//
//  LogStore.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

final class LogStore: Store {
    static let shared = LogStore()
    private(set) var logs = Property<[Log]>([])

    func update(with action: Action) {
        switch action {
        case let action as LogAction:
            switch action {
            case .debug(let message, let info):
                logs.value.append(.init(message: message, info: info, level: .debug))
            case .error(let message, let info):
                logs.value.append(.init(message: message, info: info, level: .error))
            }
        case let action as PlayerAction:
            logs.value.append(.init(message: "PlayerAction", info: action, level: .debug))
        default:
            break
        }
    }
}
