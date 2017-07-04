//
//  Queue.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation
import RealmSwift

class Queue: Object {
    dynamic var id: String = "1"
    let tracks = List<Track>()

    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
}
