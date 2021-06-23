//
//  BookPageBottomView.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/23.
//

import UIKit

class BookPageBottomView: UIView {
    private let homeIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let itemView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(itemView)
        addSubview(homeIndicatorView)
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: itemView.leadingAnchor),
            trailingAnchor.constraint(equalTo: itemView.trailingAnchor),
            topAnchor.constraint(equalTo: itemView.topAnchor),
            itemView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            itemView.bottomAnchor.constraint(equalTo: homeIndicatorView.topAnchor),
            leadingAnchor.constraint(equalTo: homeIndicatorView.leadingAnchor),
            trailingAnchor.constraint(equalTo: homeIndicatorView.trailingAnchor),
            bottomAnchor.constraint(equalTo: homeIndicatorView.bottomAnchor),
            homeIndicatorView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
