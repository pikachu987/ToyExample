//
//  NSLayoutConstraint+.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import UIKit

extension NSLayoutConstraint {
    @discardableResult
    func priority(_ priority: Float) -> NSLayoutConstraint {
        self.priority = UILayoutPriority(priority)
        return self
    }

    @discardableResult
    func identifier(_ identifier: String) -> NSLayoutConstraint {
        self.identifier = identifier
        return self
    }
}
