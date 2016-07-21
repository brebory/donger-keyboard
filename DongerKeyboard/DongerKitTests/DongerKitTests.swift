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
            it("should implement the DongerService protocol") {
                expect(DongerAPIService.getDongers()).to(beAnInstanceOf(SignalProducer), description: "DongerAPIService didn't implement getDongers")
                expect(DongerAPIService.getCategories()).to(beAnInstanceOf(SignalProducer), description: "DongerAPIService didn't implement getCatgories")
            }
        }

        describe("DongerLocalService") {
            it("should implement the DongerService protocol") {
                expect(DongerLocalService)
            }
        }
    }
}