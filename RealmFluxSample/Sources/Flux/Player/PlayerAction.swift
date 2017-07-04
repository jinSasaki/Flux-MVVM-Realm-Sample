//
//  PlayerAction.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

enum PlayerAction: Action {
    case setQueue(PendingQueue)
    case play
    case pause
    case skip
    case rewind
}

extension PlayerAction: CustomStringConvertible {
    var description: String {
        var text = "PlayerAction."
        switch self {
        case .setQueue(let queue):
            text += "setQueue: \(queue)"
        case .play:
            text += "play"
        case .pause:
            text += "pause"
        case .skip:
            text += "skip"
        case .rewind:
            text += "rewind"
        }
        return text
    }
}
