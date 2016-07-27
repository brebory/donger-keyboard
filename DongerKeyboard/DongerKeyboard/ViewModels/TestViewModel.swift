//
//  TestViewModel.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/27/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Foundation
import ReactiveCocoa
import DongerKit

class TestViewModel {
    var service: DongerService?

    var producer: SignalProducer<[Donger], ServiceError> {
        guard let service = self.service
            else { throw 
    }

    init(service: DongerService) {
        self.service = service
    }
}