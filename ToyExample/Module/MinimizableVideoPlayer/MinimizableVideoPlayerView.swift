//
//  MinimizableVideoPlayerView.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import UIKit
import AVKit

protocol MinimizableVideoPlayerViewDelegate: AnyObject {
    func minimizableVideoPlayerViewTabbarHide(_ view: MinimizableVideoPlayerView)
    func minimizableVideoPlayerViewTabbarShow(_ view: MinimizableVideoPlayerView)
}

class MinimizableVideoPlayerView: UIView {
    weak var delegate: MinimizableVideoPlayerViewDelegate?

    private let statusBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(light: .white, dark: .black)
        view.clipsToBounds = true
        return view
    }()

    private let playerView: PlayerView = {
        let view = PlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let closeMaximumButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        return button
    }()
    
    private let playMinimumButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(">", for: .normal)
        return button
    }()
    
    private let closeMinimumButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        return button
    }()
    
    private var minimumType: MinimumType {
        return constraints.filter({ $0.identifier == "height" }).first?.priority.rawValue == 750 ? .minimum : .maximum
    }
    
    private var video: MinimizableVideo? {
        didSet {
            guard let source = video?.source, let url = URL(string: source) else {
                playerView.player = nil
                return
            }
            playerView.player = AVPlayer(url: url)
        }
    }
    
    private var panGesture: UIPanGestureRecognizer?
    private var tapGesture: UITapGestureRecognizer?

    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        addSubview(statusBarView)
        addSubview(contentView)
        contentView.addSubview(playerView)
        contentView.addSubview(closeMaximumButton)
        contentView.addSubview(playMinimumButton)
        contentView.addSubview(closeMinimumButton)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 0).identifier("height").priority(750)
        ])
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: statusBarView.topAnchor),
            leadingAnchor.constraint(equalTo: statusBarView.leadingAnchor),
            trailingAnchor.constraint(equalTo: statusBarView.trailingAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height).identifier("height")
        ])
        
        NSLayoutConstraint.activate([
            statusBarView.bottomAnchor.constraint(equalTo: contentView.topAnchor).identifier("top"),
            leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: playerView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: playerView.trailingAnchor).priority(600),
            playerView.heightAnchor.constraint(equalToConstant: 300).identifier("height"),
            playerView.widthAnchor.constraint(equalToConstant: 160).identifier("width").priority(550)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: closeMaximumButton.topAnchor, constant: -12),
            contentView.leadingAnchor.constraint(equalTo: closeMaximumButton.leadingAnchor, constant: -12),
            closeMaximumButton.widthAnchor.constraint(equalToConstant: 60),
            closeMaximumButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: playMinimumButton.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: playMinimumButton.bottomAnchor),
            playMinimumButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            playMinimumButton.trailingAnchor.constraint(equalTo: closeMinimumButton.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: closeMinimumButton.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: closeMinimumButton.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: closeMinimumButton.trailingAnchor),
            closeMinimumButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        closeMinimumButton.addTarget(self, action: #selector(closeTap(_:)), for: .touchUpInside)
        closeMaximumButton.addTarget(self, action: #selector(closeTap(_:)), for: .touchUpInside)
        playMinimumButton.addTarget(self, action: #selector(playToggerTap(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(video: MinimizableVideo) {
        self.video = video
        superview?.layoutIfNeeded()
        updateMaximumLayout()
    }
    
    @objc private func minimumTap(_ sender: UIButton) {
        updateMaximumLayout()
    }
    
    @objc private func playToggerTap(_ sender: UIButton) {
        playerView.playTogger()
    }
    
    @objc private func closeTap(_ sender: UIButton) {
        playerView.stop()
        delegate?.minimizableVideoPlayerViewTabbarShow(self)
        if minimumType == .maximum {
            constraints.filter({ $0.identifier == "height" }).first?.priority(750).constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
            })
        } else {
            constraints.filter({ $0.identifier == "height" }).first?.priority(750).constant = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let viewTranslation = recognizer.translation(in: contentView)
        let viewVelocity = recognizer.velocity(in: contentView)
        
        switch recognizer.state {
        case .changed:
            if abs(viewVelocity.y) > abs(viewVelocity.x) {
                if minimumType == .maximum && -viewTranslation.y > 0 { return }
                if playerView.constraints.filter({ $0.identifier == "width" }).first?.priority.rawValue != 550 {
                    playerView.constraints.filter({ $0.identifier == "width" }).first?.priority(550)
                    removeMinimumControl()
                    UIView.animate(withDuration: 0.3) {
                        self.superview?.layoutIfNeeded()
                    }
                }
                constraints.filter({ $0.identifier == "top" }).first?.constant = -viewTranslation.y
                let progress = contentView.frame.height / (UIScreen.main.bounds.height - statusBarView.frame.height)
                backgroundColor = UIColor(white: 0, alpha: progress * 0.3)
                playerView.constraints.filter({ $0.identifier == "height" }).first?.constant = (progress * 240) + 60
                
                if viewVelocity.y > 0 && progress < 0.2 {
                    updateMinimumLayout()
                }
                
                if viewVelocity.y > 0 && progress < 0.9 {
                    removeMaximumControl()
                }
                if viewVelocity.y < 0 && progress > 0.25 {
                    removeMinimumControl()
                }
            }
        case .ended:
            if viewVelocity.y > 0 { // 아래로
                if viewTranslation.y < (UIScreen.main.bounds.height - statusBarView.frame.height) / 3 {
                    updateMaximumLayout()
                } else {
                    updateMinimumLayout()
                }
            } else { // 위로
                if viewTranslation.y < (UIScreen.main.bounds.height - statusBarView.frame.height) / 3 * 2 {
                    updateMaximumLayout()
                } else {
                    updateMinimumLayout()
                }
            }
        default: break
        }
    }
    
    @objc private func tapGesture(_ recognizer: UITapGestureRecognizer) {
        updateMaximumLayout()
    }
    
    private func addTapGesture() {
        removeTapGesture()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
    }
    
    private func removeTapGesture() {
        guard let tapGesture = tapGesture else { return }
        removeGestureRecognizer(tapGesture)
    }
    
    private func addPanGesture() {
        removePanGesture()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        addGestureRecognizer(panGesture)
        self.panGesture = panGesture
    }
    
    private func removePanGesture() {
        panGesture?.isEnabled = false
        guard let panGesture = panGesture else { return }
        removeGestureRecognizer(panGesture)
    }
    
    private func addMaximumControl() {
        closeMaximumButton.isUserInteractionEnabled = true
        closeMaximumButton.isHidden = false
    }
    
    private func removeMaximumControl() {
        closeMaximumButton.isUserInteractionEnabled = false
        closeMaximumButton.isHidden = true
    }
    
    private func addMinimumControl() {
        playMinimumButton.isUserInteractionEnabled = true
        closeMinimumButton.isUserInteractionEnabled = true
        playMinimumButton.isHidden = false
        closeMinimumButton.isHidden = false
    }
    
    private func removeMinimumControl() {
        playMinimumButton.isUserInteractionEnabled = false
        closeMinimumButton.isUserInteractionEnabled = false
        playMinimumButton.isHidden = true
        closeMinimumButton.isHidden = true
    }
    
    private func updateMinimumLayout() {
        constraints.filter({ $0.identifier == "top" }).first?.constant = 0
        constraints.filter({ $0.identifier == "height" }).first?.priority(750).constant = 60
        statusBarView.constraints.filter({ $0.identifier == "height" }).first?.constant = 0
        playerView.constraints.filter({ $0.identifier == "height" }).first?.constant = 60
        playerView.constraints.filter({ $0.identifier == "width" }).first?.priority(650)
        backgroundColor = UIColor(white: 0, alpha: 0)
        delegate?.minimizableVideoPlayerViewTabbarShow(self)
        addTapGesture()
        removePanGesture()
        addMinimumControl()
        removeMaximumControl()
        UIView.animate(withDuration: 0.3, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.addPanGesture()
        })
    }
    
    private func updateMaximumLayout() {
        constraints.filter({ $0.identifier == "top" }).first?.constant = 0
        constraints.filter({ $0.identifier == "height" }).first?.priority(650).constant = 0
        statusBarView.constraints.filter({ $0.identifier == "height" }).first?.constant = UIApplication.shared.statusBarFrame.height
        playerView.constraints.filter({ $0.identifier == "height" }).first?.constant = 300
        playerView.constraints.filter({ $0.identifier == "width" }).first?.priority(550)
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        delegate?.minimizableVideoPlayerViewTabbarHide(self)
        removeTapGesture()
        removePanGesture()
        removeMinimumControl()
        addMaximumControl()
        UIView.animate(withDuration: 0.3, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.addPanGesture()
        })
    }
    
    deinit {
        print("deinit: \(self)")
    }
}

// MARK: MinimumType
extension MinimizableVideoPlayerView {
    enum MinimumType {
        case minimum
        case maximum
    }
}

// MAKR: PlayerView
extension MinimizableVideoPlayerView {
    class PlayerView: UIView {
        private let playerLayer: AVPlayerLayer = {
            let playerLayer = AVPlayerLayer()
            
            return playerLayer
        }()
        
        var player: AVPlayer? {
            didSet {
                playerLayer.player = player
                player?.play()
            }
        }
        
        init() {
            super.init(frame: .zero)
            layer.addSublayer(playerLayer)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func play() {
            player?.play()
        }
        
        func pause() {
            player?.pause()
        }
        
        func playTogger() {
            if player?.isPlaying == true {
               pause()
            } else {
                play()
            }
        }
        
        func stop() {
            player?.pause()
            player = nil
        }
        
        override func layoutSubviews() {
            playerLayer.frame = frame
        }
    }
}

extension AVPlayer {
    fileprivate var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
