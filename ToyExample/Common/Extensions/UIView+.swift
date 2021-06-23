//
//  UIView+.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/23.
//

import UIKit

extension UIView {
    func animationLayout(withDuration: TimeInterval) {
        UIView.animate(withDuration: withDuration, animations: {
            self.layoutIfNeeded()
        })
    }
}
