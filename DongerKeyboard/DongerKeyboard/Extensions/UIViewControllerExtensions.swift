//
//  UIViewControllerExtensions.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 8/11/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit

extension UIViewController {

    private struct Constants {
        private struct Messages {
            static let OKActionTitle = "UIVIEWCONTROLLER_ALERT_OK_ACTION_TITLE"
        }
    }

    func alertError(error: CustomStringConvertible, withTitle title: String) {
        let controller = UIAlertController(title: title, message: error.description, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: Constants.Messages.OKActionTitle, style: .Default, handler: nil)
        controller.addAction(okAction)

        self.presentViewController(controller, animated: true, completion: nil)
    }
}
