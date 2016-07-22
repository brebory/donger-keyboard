//
//  DongerKitTests.swift
//  DongerKitTests
//
//  Created by Brendon Roberto on 6/23/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Quick
import Nimble
import ReactiveCocoa
@testable import DongerKit

class DongerKitSpec: QuickSpec {
    override func spec() {
        describe("DongerAPIService") {
            xit("should implement the DongerService protocol") {
                //expect(DongerAPIService.getDongers()).to(beAnInstanceOf(SignalProducer))
                //expect(DongerAPIService.getCategories()).to(beAnInstanceOf(SignalProducer))
            }
        }

        describe("DongerLocalService") {
            xit("should implement the getDongers method") {
                //expect(DongerLocalService.getDongers()).toEventually
                let producer = DongerLocalService.getDongers()
                producer.on(failed: { error in  }, completed: { }, next: { next in }).start()
            }
        }
    }
}