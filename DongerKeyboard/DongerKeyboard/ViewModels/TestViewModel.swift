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
import Result

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

    // MARK: - Properties

    private var service: DongerService
    private var disposable: Disposable?

    lazy var refresh: Action<UIControl?, [Donger], ServiceError> = { [unowned self] in
        return Action<UIControl?, [Donger], ServiceError>(self.getDongersFromService)
    }()

    let dongers: MutableProperty<[Donger]> = MutableProperty([])

    // MARK: - Initialization

    init(service: DongerService) {
        self.service = service
        self.dongers <~ self.refresh.values
    }

    // MARK: - Private Helper Methods

    private func getDongersFromService(control: UIControl?) -> SignalProducer<[Donger], ServiceError> {
        let endRefreshingClosure = { [control] in
            guard let refreshControl = control as? UIRefreshControl
                else { return }

            refreshControl.endRefreshing()
        }

        return self.service.getDongers().on(completed: endRefreshingClosure, failed: { _ in endRefreshingClosure() })
    }
}