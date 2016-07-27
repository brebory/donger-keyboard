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

        private struct Codes {
            static let Initialization = 11001
        }
    }

    case InitializationError

    public var description: String {
        switch self {
        case .InitializationError:
            let localizedString = NSLocalizedString(Constants.Messages.Initialization, comment: "Error initializing application.")
            return localizedString
        }
    }
}