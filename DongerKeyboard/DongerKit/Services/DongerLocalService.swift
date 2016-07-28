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
import SwiftyJSON

/** 
 *  Implements the static DongerService protocol by retrieving dongers
 *  from a flat file in the app bundle.
 */
 public class DongerLocalService: DongerService {

    /**
     *  Constants struct for static constants
     */
    private struct Constants {

        private struct Errors {
            private struct Messages {
                static let FileNotFound = "STR_IOERROR_FILE_NOT_FOUND"
                static let FileCorrupted = "STR_IOERROR_FILE_CORRUPTED"
            }

            private struct Codes {
                static let FileNotFound = 9001
                static let FileCorrupted = 9002
            }
        }
    }

    var filename: String?

    /**
     *  Private reference to the default NSFileManager.
     */
    private static let fileManager = NSFileManager.defaultManager()

    /**
     *  Retrieve the list of dongers from the flat file.
     *
     *  ### Example
     *  ```swift
     *  let dongerProducer = dongerService.getDongers()
     *  let dongers = MutableProperty<[Donger]>([])
     *  dongers <~ dongerProducer
     *  ```
     *
     */
    public func getDongers() -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError>() { observer, disposable in

            // Fail if the main bundle can't find a path for the requested resource.
            guard let filePath = NSBundle.mainBundle().pathForResource(self.filename ?? "", ofType: )
                else { return observer.sendFailed(.IOError(code: Constants.Errors.Codes.FileNotFound,
                                                           message: Constants.Errors.Messages.FileNotFound)) }

            // Fail if the file manager can't find or open the file at the requested path.
            guard let contents = fileManager.contentsAtPath(filePath)
                else { return observer.sendFailed(.IOError(code: Constants.Errors.Codes.FileCorrupted,
                                                           message: Constants.Errors.Messages.FileCorrupted)) }

            // Fail if the requested file can't be parsed as a json dictionary.
            guard let dictionary = JSON(contents).dictionary
                else { return observer.sendFailed(.JSONParseError) }

            let dongers = dictionary.values.map { (json) -> Donger? in
                guard let text = json.string else { return nil }
                return Donger(text: text)
            }.flatMap { $0 }

            observer.sendNext(dongers)
            observer.sendCompleted()
        }

        return producer
    }

    public func getCategories() -> SignalProducer<[Category], ServiceError> {
        let producer = SignalProducer<[Category], ServiceError> { observer, disposable in

            // Fail if the main bundle can't find a path for the requested resource.
            guard let filePath = NSBundle.mainBundle().pathForResource(Constants.FileName, ofType: Constants.FileExtension)
                else { return observer.sendFailed(.IOError(code: Constants.Errors.Codes.FileNotFound,
                    message: Constants.Errors.Messages.FileNotFound)) }

            // Fail if the file manager can't find or open the file at the requested path.
            guard let contents = fileManager.contentsAtPath(filePath)
                else { return observer.sendFailed(.IOError(code: Constants.Errors.Codes.FileCorrupted,
                    message: Constants.Errors.Messages.FileCorrupted)) }

            // Fail if the requested file can't be parsed as a json dictionary.
            guard let dictionary = JSON(contents).dictionary
                else { return observer.sendFailed(.JSONParseError) }

            let categories =  dictionary.keys.enumerate().map { (index, text) -> Category in
                return .Root(id: index, name: text)
            }

            observer.sendNext(categories)
            observer.sendCompleted()
        }

        return producer
    }

    public func getDongersForCategory(category: Category) -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError> { observer, disposable in

        }

        return producer
    }
}