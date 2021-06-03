//
//  MainType.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import Foundation

enum MainType {
    case transparent
    case shadow

    static var array: [MainType] {
        return [.transparent, .shadow]
    }
    
    static var initWithPresent: MainType? = .transparent

    var title: String? {
        switch self {
        case .transparent: return "투명뷰"
        case .shadow: return "그림자"
        }
    }
    
    func showViewController(_ viewContorller: MainViewController?) {
        switch self {
        case .transparent:
            let showViewController = TransparentViewController(nibName: nil, bundle: nil)
            viewContorller?.navigationController?.pushViewController(showViewController, animated: true)
        case .shadow:
            let showViewController = ShadowViewController(nibName: nil, bundle: nil)
            viewContorller?.navigationController?.pushViewController(showViewController, animated: true)
        }
    }
}
