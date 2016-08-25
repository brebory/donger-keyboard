//
//  UIScrollViewDelegateExtensions.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 8/25/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

public extension UIScrollViewDelegate where Self: NSObject {
    public var racx_scrollViewDidEndDeceleratingSignal: Signal<Void, NoError> {
        get {
            let racSignal = self.rac_signalForSelector(#selector(scrollViewDidEndDecelerating), fromProtocol: UIScrollViewDelegate.self)
            let result = Signal<Void, NoError> { observer -> Disposable? in
                return racSignal.subscribeNext({ _ in let x: Void; observer.sendNext(x) }, completed: { observer.sendCompleted() })
            }
            return result
        }
    }
}