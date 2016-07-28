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
    private struct Constants {
        private struct Errors {
            private struct Messages {
                static let ServiceInitialization = "STR_TESTVIEWMODEL_SERVICEINITIALIZATION_ERROR"
            }

            private struct Codes {
                static let ServiceInitialization = 11001
            }
        }
    }

    var service: DongerService?
    var disposable: Disposable?

    var signal: Signal<[Donger], ServiceError> {
        //guard let service = self.service
        //    else { return }

        service!.type
        //service?.type.getDongers().startWithSignal
    }

    init(service: DongerService) {
        self.service = service
    }
}