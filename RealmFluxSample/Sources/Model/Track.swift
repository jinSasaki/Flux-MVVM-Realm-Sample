//
//  Track.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation
import RealmSwift

final class Track: Object {
    dynamic var id: String = ""
    dynamic var name: String = ""

    override class func primaryKey() -> String? {
        return #keyPath(id)
    }

    class func find(byId id: String, realm: Realm) -> Track? {
        return realm.object(ofType: self, forPrimaryKey: id)
    }
}
