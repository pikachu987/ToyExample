//
//  MinimizableVideoPlayerListTabbarController.swift
//  ToyExample
//
//  Created by GwanhoKim on 2021/06/10.
//

import UIKit

class MinimizableVideoPlayerListTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        var viewControllers = [UIViewController]()
        if let viewController = MinimizableVideoPlayerListViewController.instance() {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.tabBarItem.title = "Home"
            viewControllers.append(navigationController)
        }
        
        let navigationController = UINavigationController(rootViewController: UIViewController())
        navigationController.tabBarItem.title = "Second"
        viewControllers.append(navigationController)
        
        setViewControllers(viewControllers, animated: true)
    }
    
    func tabBarShow(_ isShow: Bool, animation: Bool = true) {
        let yPoint = isShow ? UIScreen.main.bounds.height - tabBar.frame.height : UIScreen.main.bounds.height
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                self.tabBar.frame.origin.y = yPoint
            })
        } else {
            tabBar.frame.origin.y = yPoint
        }
    }
    
    func showPlayerVideo(_ item: MinimizableVideo) {
        guard let window = UIApplication.shared.windows.first else { return }
        
        if let playerView = window.subviews.compactMap({ $0 as? MinimizableVideoPlayerView }).first {
            playerView.show(video: item)
        } else {
            let playerView = MinimizableVideoPlayerView()
            window.addSubview(playerView)
            playerView.delegate = self
            NSLayoutConstraint.activate([
                window.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
                window.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
                window.topAnchor.constraint(equalTo: playerView.topAnchor).priority(700),
                tabBar.topAnchor.constraint(equalTo: playerView.bottomAnchor),
            ])
            playerView.show(video: item)
        }
    }
}

// MARK: MinimizableVideoPlayerViewDelegate
extension MinimizableVideoPlayerListTabbarController: MinimizableVideoPlayerViewDelegate {
    func minimizableVideoPlayerViewTabbarShow(_ view: MinimizableVideoPlayerView) {
        tabBarShow(true)
    }

    func minimizableVideoPlayerViewTabbarHide(_ view: MinimizableVideoPlayerView) {
        tabBarShow(false)
    }
}
