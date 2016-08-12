//
//  ApplicationError.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/27/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Foundation

public enum ApplicationError: ErrorType, CustomStringConvertible {

    private struct Constants {
        static let Domain = "com.snackpackgames.applicationerror"

        private struct Messages {
            static let Initialization = "STR_APPLICATION_ERROR_INIT_ERROR_MESSAGE"
            static let DataIntegrity = "STR_APPLICATION_ERROR_DATA_INTEGRITY_ERROR_MESSAGE"
        }
    }

    case InitializationError(message: String, code: Int)
    case DataIntegrityError(message: String, code: Int)

    public var description: String {
        switch self {
        case .InitializationError(let message, let code):
            let localizedString = NSLocalizedString(Constants.Messages.Initialization,
                                                    bundle: NSBundle(forClass: DongerLocalService.self),
                                                    comment: "Application Initialization Error - Code: %d, Message: %@")
            return String(format: localizedString, code, message)
        case .DataIntegrityError(let message, let code):
            let localizedString = NSLocalizedString(Constants.Messages.DataIntegrity,
                                                    bundle: NSBundle(forClass: DongerLocalService.self),
                                                    comment: "Data Integrity Error - Code: %d, Message: %@")
            return String(format: localizedString, code, message)
        }
    }

    public var code: Int {
        switch self {
        case .InitializationError(_, let code):
            return code
        case .DataIntegrityError(_, let code):
            return code
        }
    }
}