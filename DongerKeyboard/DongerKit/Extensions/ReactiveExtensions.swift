//
//  ReactiveExtensions.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 8/26/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import ReactiveCocoa
import UIKit

public func <~<Input, Output, Error>(lhs: Signal<Input, Error>, rhs: Action<Input, Output, Error>) {
    lhs.observe { event in
        if let value = event.value {
            rhs.apply(value).start()
        }
    }
}

public func <~<Input, Error>(lhs: Signal<Input, Error>, rhs: (Input) -> Disposable) {
    lhs.observe { event in
        if let value = event.value {
            rhs(value)
        }
    }
}

infix operator |< {
    associativity right
    precedence 100
}

public func |<<Input, Output, Error>(lhs: Action<Input, Output, Error>, rhs: SchedulerType) -> (Input) -> Disposable {
    return { value in lhs.apply(value).startOn(rhs).start() }
}