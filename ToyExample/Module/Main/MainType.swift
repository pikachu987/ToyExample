//
//  MainType.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import Foundation

enum MainType {
    case minimizableVideoPlayer
    case transparent
    case shadow

    static var array: [MainType] {
        return [.minimizableVideoPlayer, .transparent, .shadow]
    }
    
    static var initWithPresent: MainType? = .minimizableVideoPlayer

    var title: String? {
        switch self {
        case .minimizableVideoPlayer: return "최소화 비디오 플레이어"
        case .transparent: return "투명뷰"
        case .shadow: return "그림자"
        }
    }
    
    func showViewController(_ viewContorller: MainViewController?) {
        switch self {
        case .minimizableVideoPlayer:
            guard let showViewController = MinimizableVideoPlayerListViewController.instance() else { return }
            viewContorller?.navigationController?.pushViewController(showViewController, animated: true)
        case .transparent:
            guard let showViewController = TransparentViewController.instance() else { return }
            viewContorller?.navigationController?.pushViewController(showViewController, animated: true)
        case .shadow:
            guard let showViewController = ShadowViewController.instance() else { return }
            viewContorller?.navigationController?.pushViewController(showViewController, animated: true)
        }
    }
}
