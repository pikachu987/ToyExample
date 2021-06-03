//
//  MainType.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import Foundation

enum MainType {
    case shadow

    static var array: [MainType] {
        return [.shadow]
    }
    
    static var initWithPresent: MainType? = .shadow

    var title: String? {
        switch self {
        case .shadow: return "그림자"
        }
    }
    
    func showViewController(_ viewContorller: MainViewController?) {
        switch self {
        case .shadow:
            let showViewController = ShadowViewController(nibName: nil, bundle: nil)
            viewContorller?.navigationController?.pushViewController(showViewController, animated: true)
        }
    }
}
