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
    static func getDongers() -> SignalProducer<[Donger], ServiceError>
    static func getCategories() -> SignalProducer<[Category], ServiceError>
    static func getDongersForCategory(category: Category) -> SignalProducer<[Donger], ServiceError>
}
