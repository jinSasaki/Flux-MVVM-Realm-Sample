//
//  PlayerDispatcher.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

typealias PlayerDispatcher = AnyDispatcher<PlayerAction>

extension Dispatchers {
    static let player = PlayerDispatcher(stores: [PlayerStore.shared, LogStore.shared])
}
