//
//  PlayerStore.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import RxSwift
import RealmSwift

final class PlayerStore: Store {

    static let shared = PlayerStore()

    enum State {
        case pending
        case playing
        case paused

        var text: String {
            switch self {
            case .pending: return "Pending"
            case .playing: return "Playing"
            case .paused: return "Paused"
            }
        }
    }

    private(set) var playingIndex = Property<Int>(0)
    private(set) var state = Property<State>(.pending)
    private(set) var queue = Property<Queue?>(nil)

    private let realm: Realm
    private let disposeBag = DisposeBag()

    init(realm: Realm = try! Realm()) {
        self.realm = realm

        Observable
            .collection(from: realm.objects(Queue.self))
            .map({ $0.first })
            .bind(to: queue)
            .addDisposableTo(disposeBag)
    }

    func update(with action: Action) {
        switch action {
        case let action as PlayerAction:
            switch action {
            case .setQueue(let pendingQueue):
                try? realm.write {
                    let queue = Queue()
                    queue.tracks.append(objectsIn: pendingQueue.tracks.map({
                        let track = Track()
                        track.id = $0.id
                        track.name = $0.name
                        return track
                    }))
                    realm.add(queue, update: true)
                }
                playingIndex.value = 0
                state.value = .pending
            case .play:
                state.value = .playing
            case .pause:
                state.value = .paused
            case .skip:
                guard state.value != .pending, let tracks = queue.value?.tracks, playingIndex.value + 1 < tracks.count else {
                    playingIndex.value = 0
                    state.value = .pending
                    break
                }
                playingIndex.value += 1
            case .rewind:
                guard state.value != .pending, playingIndex.value - 1 >= 0 else {
                    playingIndex.value = 0
                    state.value = .pending
                    break
                }
                playingIndex.value -= 1
            }
        default:
            break
        }
    }
}
