//
//  DongerLocalService.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/21/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Alamofire

public class DongerLocalService: DongerService {
    public class func getDongers() -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError>() { observer, disposable in
            
        }

        return producer
    }

    public class func getCategories() -> SignalProducer<[Category], ServiceError> {
        let producer = SignalProducer<[Category], ServiceError> { observer, disposable in

        }

        return producer
    }

    public class func getDongersForCategory(category: Category) -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError> { observer, disposable in

        }

        return producer
    }
}