//
//  LogAction.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

enum LogAction: Action {
    case debug(message: String, info: Any?)
    case error(message: String, info: Any?)
}
