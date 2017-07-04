//
//  Log.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import UIKit

struct Log {
    let message: String
    let info: Any?
    let level: Level

    func buildText() -> String {
        return "[\(level.title)] \(message) \(String(describing: info))"
    }

    init(message: String, info: Any? = nil, level: Level = .debug) {
        self.message = message
        self.info = info
        self.level = level
    }

    enum Level {
        case debug
        case error

        var title: String {
            switch self {
            case .debug: return "DEBUG"
            case .error: return "ERROR"
            }
        }

        var color: UIColor {
            switch self {
            case .debug: return .lightGray
            case .error: return .red
            }
        }
    }
}
