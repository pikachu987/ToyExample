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
    
    private var navigationView: BookPageNavigationView = {
        let navigationView = BookPageNavigationView()
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        return navigationView
    }()
    
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        return pageViewController
    }()
    
    private var contents = [String]()
    
    private var isShowMenu: Bool {
        return view.constraints.filter({ $0.identifier == "top" }).first?.constant == 0
    }
    
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
        view.addSubview(navigationView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor),
            view.topAnchor.constraint(equalTo: navigationView.topAnchor).identifier("top")
        ])

        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let content = contents.first, let viewController = BookPageViewController.instance(0, content: content) {
            pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
        
        navigationView.navigationItem.title = "1 page"
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTap(_:))))
        
        navigationView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationView.isHidden = false
            self.view.constraints.filter({ $0.identifier == "top" }).first?.constant = self.navigationView.height
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        navigationView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "👈", style: .done, target: self, action: #selector(backTap(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func viewTap(_ sender: UITapGestureRecognizer) {
        if isShowMenu {
            hideMenu()
        } else {
            showMenu()
        }
        view.animationLayout(withDuration: 0.3)
    }
    
    @objc private func backTap(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func showMenu() {
        view.constraints.filter({ $0.identifier == "top" }).first?.constant = 0
    }
    
    private func hideMenu() {
        view.constraints.filter({ $0.identifier == "top" }).first?.constant = navigationView.height
    }
}

// MARK: UIPageViewControllerDelegate
extension BookPagesViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        hideMenu()
        view.animationLayout(withDuration: 0.3)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        guard let viewController = pageViewController.viewControllers?.first as? BookPageViewController else { return }
        navigationView.navigationItem.title = "\(viewController.index + 1) page"
    }
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
