//
//  Flux.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import Foundation

protocol Action {}

final class AsyncAction<A: Action> {
    private let block: (_ dispatcher: AnyDispatcher<A>) -> Void
    private let dispatchQueue: DispatchQueue

    init(dispatchQueue: DispatchQueue = .global(), _ block: @escaping (_ dispatcher: AnyDispatcher<A>) -> Void) {
        self.dispatchQueue = dispatchQueue
        self.block = block
    }

    func execute(with dispatcher: AnyDispatcher<A>) {
        block(dispatcher)
    }
}

protocol Store {
    func update(with action: Action)
}

protocol Dispatchable {
    associatedtype DispatchAction: Action
    func dispatch(_ action: DispatchAction)
    func dispatch(_ action: AsyncAction<DispatchAction>)
}

struct Dispatchers {}

final class AnyDispatcher<A: Action>: Dispatchable {
    typealias DispatchAction = A
    typealias Callback = (_ action: Action) -> Void
    private var callbacks: [Callback]

    init(stores: [Store]) {
        self.callbacks = stores.map({ store in
            return { action in
                store.update(with: action)
            }
        })
    }

    func dispatch(_ action: A) {
        callbacks.forEach({ $0(action) })
    }

    func dispatch(_ action: AsyncAction<A>) {
        action.execute(with: self)
    }
}
