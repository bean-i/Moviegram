//
//  Observable.swift
//  Moviegram
//
//  Created by 이빈 on 2/8/25.
//

import Foundation

class Observable<T> {
    
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
    
    func lazyBind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
    
}
