//
//  LogDispatcher.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

typealias LogDispatcher = AnyDispatcher<LogAction>

extension Dispatchers {
    static let log = LogDispatcher(stores: [LogStore.shared])
}
