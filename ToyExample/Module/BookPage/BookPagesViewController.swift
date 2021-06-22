//
//  BookPagesViewController.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/22.
//

import UIKit

class BookPagesViewController: UIViewController {
    static func instance() -> BookPagesViewController? {
        return BookPagesViewController()
    }
    
    private var navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar(frame: .zero)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.pushItem(UINavigationItem(), animated: false)
        return navigationBar
    }()
    
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        return pageViewController
    }()
    
    private var contents = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        view.backgroundColor = UIColor(light: .white, dark: .black)

        var pageStrings = [String]()

        for i in 1...11 {
            var contentString = "hello world: \(i) 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️\n 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️ 🟠🟡🟢🟣🟤⭐️\n\n"
            contentString.append(contentString)
            contentString.append(contentString)
            contentString.append(contentString)
            pageStrings.append(contentString)
        }

        contents = pageStrings
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(navigationBar)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor),
            view.topAnchor.constraint(equalTo: navigationBar.topAnchor, constant: navigationBar.bounds.height).identifier("top")
        ])

        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let content = contents.first, let viewController = BookPageViewController.instance(0, content: content) {
            pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigationBarTap(_:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func navigationBarTap(_ sender: UITapGestureRecognizer) {
        if view.constraints.filter({ $0.identifier == "top" }).first?.constant == -UIApplication.shared.statusBarFrame.height {
            view.constraints.filter({ $0.identifier == "top" }).first?.constant = navigationBar.bounds.height
        } else {
            view.constraints.filter({ $0.identifier == "top" }).first?.constant = -UIApplication.shared.statusBarFrame.height
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: UIPageViewControllerDelegate
extension BookPagesViewController: UIPageViewControllerDelegate {
    
}

// MARK: UIPageViewControllerDataSource
extension BookPagesViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contents.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BookPageViewController else { return nil }
        let index = viewController.index - 1
        guard let content = contents[safe: index] else { return nil }
        return BookPageViewController.instance(index, content: content)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BookPageViewController else { return nil }
        let index = viewController.index + 1
        guard let content = contents[safe: index] else { return nil }
        return BookPageViewController.instance(index, content: content)
    }
}
