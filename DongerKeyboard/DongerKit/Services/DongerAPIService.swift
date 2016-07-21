//
//  DongerAPIService.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/21/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Alamofire

public class DongerAPIService: DongerService {

    struct Constants {
        static let ServiceURL = "localhost/dongers" // TODO: Use actual service URL.
    }

    public func getDongers() -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError>() { observer, disposable in
            let request = Alamofire.request(.GET, Constants.ServiceURL, parameters: nil, encoding: .JSON, headers: nil)
            .responseJSON { response in

                if let error = response.result.error {
                    observer.sendFailed(.HTTPError(code: error.code, message: error.localizedDescription))
                } else {
                    guard let value = response.result.value
                        else { return observer.sendFailed(.JSONParseError) }
                }
            }

            disposable.addDisposable {
                request.cancel()
            }
        }

        return producer
    }
}