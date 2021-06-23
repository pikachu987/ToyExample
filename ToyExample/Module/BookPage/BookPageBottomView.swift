//
//  BookPageBottomView.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/23.
//

import UIKit

protocol BookPageBottomViewDelegate: AnyObject {
    func bookPageBottomViewPageStyle(_ view: BookPageBottomView)
}

class BookPageBottomView: UIView {
    weak var delegate: BookPageBottomViewDelegate?

    private let homeIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(light: 240/255, dark: 34/255)
        return view
    }()
    
    private let itemView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(light: 240/255, dark: 34/255)
        return view
    }()
    
    private let pageStyleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor(light: .black, dark: .white), for: .normal)
        return button
    }()
    
    private var homeIndicatorHeight: CGFloat = 0
    private var itemViewHeight: CGFloat = 44
    
    var height: CGFloat {
        return itemViewHeight + homeIndicatorHeight
    }
    
    var pageStyle: String = "" {
        didSet {
            pageStyleButton.setTitle(pageStyle, for: .normal)
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        addSubview(itemView)
        addSubview(homeIndicatorView)
        itemView.addSubview(pageStyleButton)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
            trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
            topAnchor.constraint(equalTo: itemView.topAnchor),
            itemView.heightAnchor.constraint(equalToConstant: itemViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            itemView.bottomAnchor.constraint(equalTo: homeIndicatorView.topAnchor),
            leadingAnchor.constraint(equalTo: homeIndicatorView.leadingAnchor),
            trailingAnchor.constraint(equalTo: homeIndicatorView.trailingAnchor),
            bottomAnchor.constraint(equalTo: homeIndicatorView.bottomAnchor),
            homeIndicatorView.heightAnchor.constraint(equalToConstant: 44).identifier("height")
        ])
        
        NSLayoutConstraint.activate([
            itemView.topAnchor.constraint(equalTo: pageStyleButton.topAnchor),
            itemView.leadingAnchor.constraint(equalTo: pageStyleButton.leadingAnchor),
            pageStyleButton.widthAnchor.constraint(equalToConstant: 48),
            pageStyleButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        pageStyleButton.addTarget(self, action: #selector(pageStyleTap(_:)), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.homeIndicatorHeight = self.safeAreaInsets.bottom
            self.homeIndicatorView.constraints.filter({ $0.identifier == "height" }).first?.constant = self.homeIndicatorHeight
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pageStyleTap(_ sender: UIButton) {
        delegate?.bookPageBottomViewPageStyle(self)
    }
}
