//
//  BookPageNavigationView.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/23.
//

import UIKit

class BookPageNavigationView: UIView {
    private let statusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(light: 240/255, dark: 34/255)
        return view
    }()
    
    private let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: .zero)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.pushItem(UINavigationItem(), animated: false)
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor(light: 240/255, dark: 34/255)
        return navigationBar
    }()
    
    private var statusHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    var height: CGFloat {
        return navigationBar.bounds.height + statusHeight
    }
    
    var navigationItem: UINavigationItem {
        return navigationBar.topItem ?? UINavigationItem()
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(statusView)
        addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: statusView.leadingAnchor),
            trailingAnchor.constraint(equalTo: statusView.trailingAnchor),
            topAnchor.constraint(equalTo: statusView.topAnchor),
            statusView.heightAnchor.constraint(equalToConstant: statusHeight)
        ])
        
        NSLayoutConstraint.activate([
            statusView.bottomAnchor.constraint(equalTo: navigationBar.topAnchor),
            leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
