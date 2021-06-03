//
//  Array+Safe.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
