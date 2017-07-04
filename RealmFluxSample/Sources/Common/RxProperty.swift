//
//  RxProperty.swift
//  RealmFluxSample
//
//  Created by Jin Sasaki on 2017/07/04.
//  Copyright © 2017年 sasakky. All rights reserved.
//

import RxSwift

public struct Property<Element> {
    public typealias E = Element
    fileprivate let _variable: Variable<E>
    public var value: E {
        get {
            return _variable.value
        }
        set(newValue) {
            _variable.value = newValue
        }
    }

    public init(_ value: Element) {
        _variable = Variable<Element>(value)
    }

    public func asObservable() -> Observable<E> {
        return _variable.asObservable()
    }
}

extension ObservableType {
    public func bind(to variable: Property<E>) -> Disposable {
        return subscribe { e in
            switch e {
            case let .next(element):
                variable._variable.value = element
            case let .error(error):
                let error = "Binding error to variable: \(error)"
                print(error)
            case .completed:
                break
            }
        }
    }

    public func bind(to variable: Property<E?>) -> Disposable {
        return self.map { $0 as E? }.bind(to: variable)
    }
}

