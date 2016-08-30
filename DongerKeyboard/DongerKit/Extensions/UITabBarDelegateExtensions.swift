//
//  UITabBarDelegateExtensions.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 8/30/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit
import ReactiveCocoa
import Result

public extension UITabBarDelegate where Self: NSObject {
    public var racx_tabBarDidSelectItemSignal: Signal<UITabBarItem, NoError> {
        get {
            let racSignal = self.rac_signalForSelector(#selector(tabBar(_:didSelectItem:)), fromProtocol: UITabBarDelegate.self)
            let result = Signal<UITabBarItem, NoError> { observer -> Disposable? in
                return racSignal.subscribeNext({ next in
                    let item: UITabBarItem = next.0
                    observer.sendNext(next.0)
                }, completed: { observer.sendCompleted() })
            }
            return result
        }
    }
}