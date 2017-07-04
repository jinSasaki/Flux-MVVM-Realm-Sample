//
//  PlayerViewModel.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import RxSwift
import RxCocoa

final class PlayerViewModel {

    let logs: Observable<[Log]>

    let playerQueue: Observable<PlayerQueue>
    private(set) var pendingQueue = Property<PendingQueue>(PendingQueue())

    private let playerStore: PlayerStore
    private let playerDispatcher: PlayerDispatcher
    private let disposeBag = DisposeBag()

    struct PlayerQueue {
        enum State {
            case pending
            case paused(index: Int)
            case playing(index: Int)
        }
        let queue: Queue
        let state: State

        struct Track {
            let shouldFocus: Bool
            let isPlaying: Bool
            let track: RealmFluxSample.Track
        }

        func tracks() -> [Track] {
            return queue.tracks.toArray().enumerated().map({
                switch self.state {
                case .pending:
                    return Track(shouldFocus: false, isPlaying: false, track: $0.element)
                case .paused(let index):
                    return Track(shouldFocus: index == $0.offset, isPlaying: false, track: $0.element)
                case .playing(let index):
                    return Track(shouldFocus: index == $0.offset, isPlaying: index == $0.offset, track: $0.element)
                }
            })
        }
    }

    init(playerStore: PlayerStore = .shared,
         playerDispatcher: PlayerDispatcher = Dispatchers.player,
         logStore: LogStore = .shared) {

        self.playerStore = playerStore
        self.playerDispatcher = playerDispatcher

        logs = logStore.logs.asObservable()

        playerQueue = Observable
            .combineLatest(
                playerStore.queue.asObservable(),
                playerStore.state.asObservable(),
                playerStore.playingIndex.asObservable()
            )
            .map({
                let queue = $0.0 ?? Queue()
                let state: PlayerQueue.State
                switch $0.1 {
                case .playing: state = .playing(index: $0.2)
                case .paused: state = .paused(index: $0.2)
                case .pending: state = .pending
                }
                return PlayerQueue(queue: queue, state: state)
            })
    }

    func observe(setQueueButtonControl: ControlEvent<Void>,
                 playButtonControl: ControlEvent<Void>,
                 pauseButtonControl: ControlEvent<Void>,
                 skipButtonControl: ControlEvent<Void>,
                 rewindButtonControl: ControlEvent<Void>,
                 addTrackAButtonControl: ControlEvent<Void>,
                 addTrackBButtonControl: ControlEvent<Void>) {

        setQueueButtonControl
            .map({ [weak self] () -> PendingQueue? in
                self?.pendingQueue.value
            })
            .filterNil()
            .subscribe(onNext: { [weak self] in
                self?.playerDispatcher.dispatch(.setQueue($0))
                self?.pendingQueue.value = PendingQueue()
            })
            .addDisposableTo(disposeBag)

        playButtonControl
            .subscribe(onNext: { [weak self] _ in
                self?.playerDispatcher.dispatch(.play)
            })
            .addDisposableTo(disposeBag)

        pauseButtonControl
            .subscribe(onNext: { [weak self] _ in
                self?.playerDispatcher.dispatch(.pause)
            })
            .addDisposableTo(disposeBag)

        skipButtonControl
            .subscribe(onNext: { [weak self] _ in
                self?.playerDispatcher.dispatch(.skip)
            })
            .addDisposableTo(disposeBag)

        rewindButtonControl
            .subscribe(onNext: { [weak self] _ in
                self?.playerDispatcher.dispatch(.rewind)
            })
            .addDisposableTo(disposeBag)

        addTrackAButtonControl
            .subscribe(onNext: { [weak self] _ in
                let track = PendingQueue.Track(id: "track_a", name: "TRACK A")
                self?.pendingQueue.value.tracks.append(track)
            })
            .addDisposableTo(disposeBag)

        addTrackBButtonControl
            .subscribe(onNext: { [weak self] _ in
                let track = PendingQueue.Track(id: "track_b", name: "TRACK B")
                self?.pendingQueue.value.tracks.append(track)
            })
            .addDisposableTo(disposeBag)
    }
}
