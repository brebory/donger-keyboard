//
//  SignalProducerMatchers.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/22/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import ReactiveCocoa
import Nimble

public func haveNext<T, E: ErrorType>(next: T, timeout: Int? = nil) -> MatcherFunc<SignalProducer<T, E>> {
    return MatcherFunc { actual, failure in
        failure.postfixMessage = "include next: \(next)"
        guard let producer = try actual.evaluate() else { return false }
        
    }
}
