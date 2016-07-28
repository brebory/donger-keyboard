//
//  DongerService.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/21/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol DongerService {
    func getDongers() -> SignalProducer<[Donger], ServiceError>
    func getCategories() -> SignalProducer<[Category], ServiceError>
    func getDongersForCategory(category: Category) -> SignalProducer<[Donger], ServiceError>
}
