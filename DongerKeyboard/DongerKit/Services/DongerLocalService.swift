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

public class DongerLocalService: DongerService {

    private struct Constants {
        static let FileName = "dongers"
        static let FileExtension = "json"

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

    private static let fileManager = NSFileManager.defaultManager()

    public class func getDongers() -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError>() { observer, disposable in

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

            let dongers = dictionary.values.map { (json) -> Donger? in
                guard let text = json.string else { return nil }
                return Donger(text: text)
            }.flatMap { $0 }

            observer.sendNext(dongers)
            observer.sendCompleted()
        }

        return producer
    }

    public class func getCategories() -> SignalProducer<[Category], ServiceError> {
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

    public class func getDongersForCategory(category: Category) -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError> { observer, disposable in

        }

        return producer
    }
}