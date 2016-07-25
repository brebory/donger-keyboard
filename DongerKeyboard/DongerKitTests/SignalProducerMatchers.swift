//
//  SignalProducerMatchers.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/22/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import ReactiveCocoa
import Nimble
import enum Result.NoError
public typealias NoError = Result.NoError

public func haveNext<T, E: ErrorType where T: Equatable>(expected: T, timeout: Int? = nil) -> MatcherFunc<SignalProducer<T, E>> {
    return MatcherFunc { actual, failure in
        failure.postfixMessage = "include next: \(expected)"
        var result = false
        guard let producer = try actual.evaluate() else { return false }

        let blockingProducer = producer.reduce(false) { $0 || ($1 == expected) }
        let complete = blockingProducer.on(next: { next in result = next }).wait()

        switch complete {
        case .Success:
            return result
        case .Failure:
            return false
        }
    }
}
