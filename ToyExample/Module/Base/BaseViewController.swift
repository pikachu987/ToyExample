//
//  BaseViewController.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(light: .white, dark: .black)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        removeNotification()
        addNotification()
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeNotification()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            colorModeDidChange()
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationApplicationWillResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationApplicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationApplicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationApplicationDidBecomeActive(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChangeDetect(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

extension BaseViewController {
    @objc func notificationKeyboardWillShow(_ notification: Notification) { }
    @objc func notificationKeyboardWillHide(_ notification: Notification) { }
    @objc func notificationApplicationWillResignActive(_ notification: Notification) { }
    @objc func notificationApplicationDidEnterBackground(_ notification: Notification) { }
    @objc func notificationApplicationWillEnterForeground(_ notification: Notification) { }
    @objc func notificationApplicationDidBecomeActive(_ notification: Notification) { }
    @objc func orientationDidChangeDetect(_ notification: Notification) { }
    func colorModeDidChange() { }
}

extension UIViewController {
    private final class Deallocator {

        var closure: () -> Void

        init(_ closure: @escaping () -> Void) {
            self.closure = closure
        }

        deinit {
            closure()
        }
    }

    static private var associatedObjectAddr = ""

    @objc private func swizzled_viewDidLoad() {
        let deinitText = "deinit: \(self)"
        let deallocator = Deallocator { print(deinitText) }
        objc_setAssociatedObject(self, &UIViewController.associatedObjectAddr, deallocator, .OBJC_ASSOCIATION_RETAIN)
        swizzled_viewDidLoad()
    }

    static let deinitSwizzle: Void = {
        let originalSelector = #selector(viewDidLoad)
        let swizzledSelector = #selector(swizzled_viewDidLoad)
        let forClass: AnyClass = UIViewController.self
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }()
}
