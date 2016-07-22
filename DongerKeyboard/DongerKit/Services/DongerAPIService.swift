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
import SwiftyJSON

public class DongerAPIService: DongerService {

    struct Constants {
        static let ServiceURL = "localhost/dongers" // TODO: Use actual service URL.

        struct Validation {
            static let StatusCodes = 200..<300
            static let ContentType = ["application/json"]
        }

        struct Services {
            static let GetDongers = "getdongers"
            static let GetCategories = "getcategories"
            static let GetDongersForCategory = "getdongersforcategory"
        }

        struct Keys {
            static let Dongers = "dongers"
        }
    }

    // MARK: DongerService

    public class func getDongers() -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError>() { observer, disposable in
            let request = createRequest(Constants.Services.GetDongers)

            request.responseJSON { response in

                switch response.result {

                case .Success(let data):
                    guard let dongers = JSON(data)[Constants.Keys.Dongers].array?.flatMap({ json in Donger(text: json.stringValue) })
                        else { return observer.sendFailed(.JSONParseError) }
                    observer.sendNext(dongers)
                    observer.sendCompleted()

                case .Failure(let error):
                    observer.sendFailed(.HTTPError(code: error.code, message: error.localizedDescription))
                }
            }

            disposable.addDisposable {
                request.cancel()
            }
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

    // MARK: Private Helpers

    private class func createRequest(serviceName: String) -> Request {
        return Alamofire.request(.GET, "\(Constants.ServiceURL)/\(serviceName)")
            .validate(statusCode: Constants.Validation.StatusCodes)
            .validate(contentType: Constants.Validation.ContentType)
    }
}