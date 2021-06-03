//
//  BaseNavigationController.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import UIKit

extension UINavigationController {
    open override func loadView() {
        super.loadView()

        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        if let alertController = visibleViewController as? UIAlertController {
            if let navigationController = alertController.presentingViewController as? UINavigationController {
                if let tabBarController = navigationController.topViewController as? UITabBarController {
                    return tabBarController.selectedViewController?.preferredStatusBarStyle ?? .lightContent
                } else if let viewController = navigationController.topViewController {
                    return viewController.preferredStatusBarStyle
                } else {
                    return .lightContent
                }
            } else if let viewController = alertController.presentingViewController {
                return viewController.preferredStatusBarStyle
            } else {
                return .lightContent
            }
        } else if let tabBarController = visibleViewController as? UITabBarController {
            return tabBarController.selectedViewController?.preferredStatusBarStyle ?? .lightContent
        } else if let viewController = visibleViewController {
            return viewController.preferredStatusBarStyle
        } else {
            return .lightContent
        }
    }
}

// MARK: UIGestureRecognizerDelegate
extension UINavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
