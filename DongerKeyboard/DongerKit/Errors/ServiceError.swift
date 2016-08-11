//
//  ServiceError.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/21/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import Foundation

public enum ServiceError: ErrorType, CustomStringConvertible {

    private struct Constants {
        static let Domain = "com.snackpackgames.serviceerror"

        private struct Messages {
            static let HTTP = "STR_SERVICE_ERROR_HTTP_ERROR_MESSAGE"
            static let JSONParse = "STR_SERVICE_ERROR_JSON_PARSE_ERROR_MESSAGE %d %@"
            static let IO = "STR_SERVICE_ERROR_IO_ERROR_MESSAGE"
            static let Lifecycle = "STR_SERVICE_ERROR_LIFECYCLE_ERROR_MESSAGE"
            static let Unspecified = "STR_SERVICE_ERROR_UNSPECIFIED_ERROR_MESSAGE"
        }

        private struct Codes {
            static let JSONParse = 10001
            static let Lifecycle = 10002
        }
    }

    case HTTPError(code: Int, message: String)
    case JSONParseError(message: String)
    case IOError(code: Int, message: String)
    case LifecycleError
    case UnspecifiedError(code: Int)

    public var description: String {
        switch self {
        case .HTTPError(let code, let message):
            let localizedString = NSLocalizedString(Constants.Messages.HTTP,
                                                    comment: "HTTP Error - Code: %@, Message: %@")
            return String(format: localizedString, code, message)

        case .JSONParseError(let message):
            let localizedString = NSLocalizedString(Constants.Messages.JSONParse,
                                                    comment: "JSON Parse Error - Code: %@, Message: Couldn't parse JSON response. %@")
            return String(format: localizedString, code, message)

        case .IOError(let code, let message):
            let localizedString = NSLocalizedString(Constants.Messages.IO,
                                                    comment: "IO Error - Code: %@, Message: %@")
            return String(format: localizedString, code, message)

        case .LifecycleError:
            let localizedString = NSLocalizedString(Constants.Messages.Lifecycle,
                                                    comment: "Lifecycle Error - Code: %@, Message: Object has gone out of scope.")
            return String(format: localizedString, code)
        case .UnspecifiedError(let code):
            let localizedString = NSLocalizedString(Constants.Messages.Unspecified,
                                                    comment: "Unspecified Error - Code: %@, Message: An unspecified error occured.")
            return String(format: localizedString, code)
        }
    }

    public var code: Int {
        switch self {
        case .HTTPError(let code, _):
            return code
        case .JSONParseError:
            return Constants.Codes.JSONParse
        case .IOError(let code, _):
            return code
        case .LifecycleError:
            return Constants.Codes.Lifecycle
        case .UnspecifiedError(let code):
            return code
        }
    }
}