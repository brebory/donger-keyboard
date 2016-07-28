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
        }
    }

    case InitializationError(message: String, code: Int)

    public var description: String {
        switch self {
        case .InitializationError(let message, _):
            let localizedString = NSLocalizedString(Constants.Messages.Initialization,
                                                    comment: "Error initializing application: <message>")
            return String(format: localizedString, message)
        }
    }

    public var code: Int {
        switch self {
        case .InitializationError(_, let code):
            return code
        }
    }
}