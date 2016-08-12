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
 public class DongerLocalService {

    /**
     *  Constants struct for static constants
     */
    private struct Constants {

        private struct Errors {
            private struct Messages {
                static let FileNotFound = "STR_IOERROR_DONGERLOCALSERVICE_FILE_NOT_FOUND"
                static let FileCorrupted = "STR_IOERROR_DONGERLOCALSERVICE_FILE_CORRUPTED"
            }

            private struct Codes {
                static let FileNotFound = 9001
                static let FileCorrupted = 9002
            }
        }

        static let JSONFileType = "json"
    }

    // MARK: - Static Properties

    /**
     *  Private reference to the default NSFileManager.
     */
    private static let fileManager = NSFileManager.defaultManager()

    // MARK: - Instance Properties

    var filename: String

    // MARK: - Initializers

    public init(filename: String) {
        self.filename = filename
    }
}

// MARK: - DongerService Methods

extension DongerLocalService: DongerService {

    // MARK: - Protocol Methods

    /**
     Retrieve the list of dongers from the flat file.

     ### Example
     ```swift
     let dongerProducer = dongerService.getDongers()
     let dongers = MutableProperty<[Donger]>([])
     dongers <~ dongerProducer
     ```

     - returns: A SignalProducer for the array of dongers in the flat file.
     */
    public func getDongers() -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError>() { [weak self] observer, disposable in

            guard let strongSelf = self
                else { return observer.sendFailed(.LifecycleError) }

            do {
                let filePath = try strongSelf.getPathForFilename(strongSelf.filename, fileType: Constants.JSONFileType)
                let contents = try strongSelf.getContentsForPath(filePath)
                let dictionary = try strongSelf.parseContentsAsJSON(contents)
                let dongers =  strongSelf.parseJSONAsDongers(dictionary)

                observer.sendNext(dongers)
                observer.sendCompleted()

            } catch let error as ServiceError {
                observer.sendFailed(error)
            } catch {
                observer.sendFailed(.UnspecifiedError(code: error._code))
            }

        }

        return producer
    }

    /**


     - returns: <#return value description#>
     */
    public func getCategories() -> SignalProducer<[Category], ServiceError> {
        let producer = SignalProducer<[Category], ServiceError> { [weak self] observer, disposable in

            guard let strongSelf = self
                else { return observer.sendFailed(.LifecycleError) }

            do {
                let filePath = try strongSelf.getPathForFilename(strongSelf.filename, fileType: Constants.JSONFileType)
                let contents = try strongSelf.getContentsForPath(filePath)
                let dictionary = try strongSelf.parseContentsAsJSON(contents)
                let categories =  strongSelf.parseJSONAsCategories(dictionary)

                observer.sendNext(categories)
                observer.sendCompleted()

            } catch let error as ServiceError {
                observer.sendFailed(error)
            } catch {
                observer.sendFailed(.UnspecifiedError(code: error._code))
            }
        }

        return producer
    }

    // TODO: Implement
    public func getDongersForCategory(category: Category) -> SignalProducer<[Donger], ServiceError> {
        let producer = SignalProducer<[Donger], ServiceError> { observer, disposable in
            // Get the dongers for the specific category from the file at self.filename.
        }

        return producer
    }

    // MARK: - Private DongerService Helper Methods

    /**
     Gets the fully qualified path for the specified file in the current framework bundle.
     Uses NSBundle(forClass:) to obtain the current framework bundle.

     - parameter filename: The filename to search for.
     - parameter fileType: The file extension to search for.

     - throws: ServiceError.IOError if the file is not found.

     - returns: The full pathname for the resource.
     */
    private func getPathForFilename(filename: String, fileType: String) throws -> String {
        // Fail if the main bundle can't find a path for the requested resource.
        guard let filePath = NSBundle(forClass: self.dynamicType.self).pathForResource(filename, ofType: fileType)
            else {
                let message = NSLocalizedString(Constants.Errors.Messages.FileNotFound,
                                                bundle: NSBundle(forClass: DongerLocalService.self),
                                                comment: "The file \"%@\" was not found.")
                throw ServiceError.IOError(code: Constants.Errors.Codes.FileNotFound,
                                           message: String(format: message, filename))
        }
        return filePath
    }

    // TODO: Document
    private func getContentsForPath(path: String) throws -> NSData {
        // Fail if the file manager can't find or open the file at the requested path.
        guard let contents = self.dynamicType.fileManager.contentsAtPath(path)
            else {
                let message = NSLocalizedString(Constants.Errors.Messages.FileCorrupted,
                                                bundle: NSBundle(forClass: DongerLocalService.self),
                                                comment: "The file at the path \"%@\" was corrupted or couldn't be opened")
                throw ServiceError.IOError(code: Constants.Errors.Codes.FileCorrupted,
                                           message: String(format: message, path))
        }
        return contents
    }

    // TODO: Document
    private func parseContentsAsJSON(contents: NSData) throws -> [String : JSON] {
        // Fail if the requested file can't be parsed as a json dictionary.
        let jsonObject = try NSJSONSerialization.JSONObjectWithData(contents, options: .AllowFragments)
        guard let dictionary = JSON(jsonObject).dictionary
            else { throw ServiceError.JSONParseError(message: JSON(contents).error?.description ?? "") }
        return dictionary
    }

    // TODO: Document
    private func parseJSONAsDongers(json: [String : JSON]) -> [Donger] {
        return Array(json.values).reduce([JSON]()) { $0 + $1.arrayValue }.map { (json) -> Donger? in
            guard let text = json.string else { return nil }
            return Donger(text: text)
        }.flatMap { $0 }
    }

    // TODO: Document
    private func parseJSONAsCategories(json: [String : JSON]) -> [Category] {
        return json.keys.enumerate().map { (index, text) -> Category in
            return .Root(id: index, name: text)
        }
    }
}