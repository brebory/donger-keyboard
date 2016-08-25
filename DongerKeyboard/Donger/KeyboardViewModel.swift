//
//  KeyboardViewModel.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 8/23/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Foundation
import ReactiveCocoa
import DongerKit
import Result

class KeyboardViewModel {

    typealias DongerCategory = DongerKit.Category

    lazy var refreshCategories: Action<UIControl?, [DongerCategory], ServiceError> = { [unowned self] in
        return Action<UIControl?, [DongerCategory], ServiceError>(self.getCategories)
    }()

    lazy var updateCurrentCategory: Action<DongerCategory, [Donger], ServiceError> = { [unowned self] in
        return Action<DongerCategory, [Donger], ServiceError>(self.getDongersForCategory)
    }()

    let dongers = MutableProperty<[Donger]>([])
    let categories = MutableProperty<[DongerCategory]>([])

    private var service: DongerService

    init(service: DongerService) {
        self.service = service
        self.categories <~ refreshCategories.values
        self.dongers <~ updateCurrentCategory.values
    }

    private func getCategories(control: UIControl?) -> SignalProducer<[DongerCategory], ServiceError> {

    }


    private func getDongersForCategory(category: DongerCategory) -> SignalProducer<[Donger], ServiceError> {

    }
}
