//
//  RxSwift.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import RxSwift

// MARK: - filterNil

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? { return self }
}

extension ObservableType where E: OptionalType {
    func filterNil() -> Observable<E.Wrapped> {
        return filter { $0.value != nil }.map { $0.value! }
    }
}

extension ObservableType where E == String {
    func filterBlank() -> Observable<E> {
        return filter { $0.characters.count > 0 }
    }
}

