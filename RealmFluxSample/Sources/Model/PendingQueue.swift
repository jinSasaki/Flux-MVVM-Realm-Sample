//
//  PendingQueue.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

struct PendingQueue {
    struct Track {
        let id: String
        let name: String
    }

    var tracks: [Track]
    init(tracks: [Track] = []) {
        self.tracks = tracks
    }
}
