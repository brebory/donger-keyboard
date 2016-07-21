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
            static let JSONParse = "STR_SERVICE_ERROR_JSON_PARSE_ERROR_MESSAGE"
        }

        private struct ErrorCodes {
            static let JSONParse = 10001
        }
    }

    case HTTPError(code: Int, message: String)
    case JSONParseError

    public var description: String {
        switch self {
        case .HTTPError(_, let message):
            let localizedString = NSLocalizedString(Constants.Messages.HTTP,
                                                    comment: "HTTP Error - Code: %@, Message: %@")
            return String(format: localizedString, code, message)

        case .JSONParseError:
            let localizedString = NSLocalizedString(Constants.Messages.JSONParse,
                                                    comment: "JSON Parse Error - Couldn't parse JSON response.")
            return localizedString
        }
    }

    public var code: Int {
        switch self {
        case .HTTPError(let code, _):
            return code
        case .JSONParseError:
            return Constants.ErrorCodes.JSONParse
        }
    }
}