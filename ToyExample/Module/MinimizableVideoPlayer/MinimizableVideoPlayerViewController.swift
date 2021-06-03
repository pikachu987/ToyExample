//
//  MinimizableVideoPlayerViewController.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import UIKit
import AVKit

class MinimizableVideoPlayerViewController: BaseViewController {
    static func instance(_ item: MinimizableVideo) -> MinimizableVideoPlayerViewController? {
        return MinimizableVideoPlayerViewController()
    }
    
    private let playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let playerLayer: AVPlayerLayer = {
        let playerLayer = AVPlayerLayer()
        
        return playerLayer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(playerView)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: playerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: playerView.trailingAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        view.isOpaque = false
            view.backgroundColor = .clear
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension MinimizableVideoPlayerViewController {
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        let viewTranslation = sender.translation(in: view)
        print("viewTranslation: \(viewTranslation)")
        switch sender.state {
        case .changed:
            if viewTranslation.y < 0 { return }
//            UIView.animate(withDuration: 0.5, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: viewTranslation.y)
//            })
            
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.transform = .identity
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height - 140 - self.view.safeAreaInsets.bottom)
                })
            }
        default:
            break
        }
    }
}
