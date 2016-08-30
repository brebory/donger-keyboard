//
//  UIControlExtensions.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 8/11/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

public extension UIControl {
    func racx_addAction<Input, Output, Error>(action: Action<Input, Output, Error>, forControlEvents controlEvents: UIControlEvents) -> Disposable {

        let cocoaAction = action.unsafeCocoaAction
        self.addTarget(cocoaAction, action: cocoaAction.dynamicType.selector, forControlEvents: controlEvents)

        return ActionDisposable { [weak self, cocoaAction, controlEvents] in
            self?.removeTarget(cocoaAction, action: cocoaAction.dynamicType.selector, forControlEvents: controlEvents)
        }
    }
}