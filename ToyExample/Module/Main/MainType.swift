//
//  MainType.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import Foundation
import UIKit

enum MainType {
    case minimizableVideoPlayer
    case bookPages
    case transparent
    case shadow

    static var array: [MainType] {
        return [.minimizableVideoPlayer, bookPages, .transparent, .shadow]
    }
    
    static var initWithPresent: MainType? = nil

    var title: String? {
        switch self {
        case .minimizableVideoPlayer: return "최소화 비디오 플레이어"
        case .bookPages: return "책 페이지"
        case .transparent: return "투명뷰"
        case .shadow: return "그림자"
        }
    }
    
    var viewController: UIViewController? {
        switch self {
        case .minimizableVideoPlayer:
            return MinimizableVideoPlayerListTabbarController()
        case .bookPages:
            return BookPagesViewController.instance()
        case .transparent:
            return TransparentViewController.instance()
        case .shadow:
            return ShadowViewController.instance()
        }
    }
    
    var isPush: Bool {
        if self == .minimizableVideoPlayer {
            return false
        }
        return true
    }
    
    func showViewController(_ viewContorller: MainViewController?) {
        guard let showViewController = viewController else { return }
        if isPush {
            viewContorller?.navigationController?.pushViewController(showViewController, animated: true)
        } else {
            showViewController.modalPresentationStyle = .fullScreen
            viewContorller?.present(showViewController, animated: true, completion: nil)
        }
    }
}
