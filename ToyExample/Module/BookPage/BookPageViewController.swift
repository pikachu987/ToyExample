//
//  BookPageViewController.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/22.
//

import UIKit

class BookPageViewController: UIViewController {
    static func instance(_ index: Int, content: String) -> BookPageViewController? {
        return BookPageViewController(index: index, content: content)
    }
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.textColor = UIColor(light: .black, dark: .white)
        return textView
    }()

    let index: Int
    let content: String
    
    private init(index: Int, content: String) {
        self.index = index
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(light: .white, dark: .black)
        
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: textView.leadingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: textView.topAnchor),
            view.bottomAnchor.constraint(equalTo: textView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: textView.trailingAnchor)
        ])
        
        textView.text = content
    }
}
