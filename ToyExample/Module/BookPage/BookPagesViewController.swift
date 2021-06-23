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
    
    private var bottomView: BookPageBottomView = {
        let bottomView = BookPageBottomView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        return bottomView
    }()
    
    private var horizontalPageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        return pageViewController
    }()
    
    private var verticalPageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
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
        
        addChild(horizontalPageViewController)
        addChild(verticalPageViewController)

        view.addSubview(horizontalPageViewController.view)
        view.addSubview(verticalPageViewController.view)

        view.addSubview(navigationView)
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: horizontalPageViewController.view.leadingAnchor),
            view.topAnchor.constraint(equalTo: horizontalPageViewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: horizontalPageViewController.view.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: horizontalPageViewController.view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: verticalPageViewController.view.leadingAnchor),
            view.topAnchor.constraint(equalTo: verticalPageViewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: verticalPageViewController.view.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: verticalPageViewController.view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor),
            view.topAnchor.constraint(equalTo: navigationView.topAnchor).identifier("top")
        ])
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).identifier("bottom")
        ])

        horizontalPageViewController.delegate = self
        horizontalPageViewController.dataSource = self

        verticalPageViewController.delegate = self
        verticalPageViewController.dataSource = self
        
        bottomView.delegate = self
        
        if let content = contents.first {
            if let viewController = BookPageViewController.instance(0, content: content) {
                verticalPageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
            }
            if let viewController = BookPageViewController.instance(0, content: content) {
                horizontalPageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
            }
        }
        
        navigationView.navigationItem.title = "1 page"
        bottomView.pageStyle = "👇"
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTap(_:))))
        
        verticalPageViewController.view.isHidden = true
        
        navigationView.isHidden = true
        bottomView.isHidden = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.navigationView.isHidden = false
            self.bottomView.isHidden = false
            self.view.constraints.filter({ $0.identifier == "top" }).first?.constant = self.navigationView.height
            self.view.constraints.filter({ $0.identifier == "bottom" }).first?.constant = -self.bottomView.height
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
        view.constraints.filter({ $0.identifier == "bottom" }).first?.constant = 0
    }
    
    private func hideMenu() {
        view.constraints.filter({ $0.identifier == "top" }).first?.constant = navigationView.height
        view.constraints.filter({ $0.identifier == "bottom" }).first?.constant = -bottomView.height
    }
    
    private func makePageViewController(_ index: Int) -> UIViewController? {
        guard let content = contents[safe: index] else { return nil }
        return BookPageViewController.instance(index, content: content)
    }
}

// MARK: BookPageBottomViewDelegate
extension BookPagesViewController: BookPageBottomViewDelegate {
    func bookPageBottomViewPageStyle(_ view: BookPageBottomView) {
        if verticalPageViewController.view.isHidden {
            verticalPageViewController.view.isHidden = false
            horizontalPageViewController.view.isHidden = true
            bottomView.pageStyle = "👉"
        } else {
            verticalPageViewController.view.isHidden = true
            horizontalPageViewController.view.isHidden = false
            bottomView.pageStyle = "👇"
        }
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
        
        guard let contentPageViewController = makePageViewController(viewController.index) else { return }
        if pageViewController === horizontalPageViewController {
            verticalPageViewController.delegate = nil
            verticalPageViewController.setViewControllers([contentPageViewController], direction: .forward, animated: false)
            verticalPageViewController.delegate = self
        } else if pageViewController === verticalPageViewController {
            horizontalPageViewController.delegate = nil
            horizontalPageViewController.setViewControllers([contentPageViewController], direction: .forward, animated: false)
            horizontalPageViewController.delegate = self
        }
    }
}

// MARK: UIPageViewControllerDataSource
extension BookPagesViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contents.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BookPageViewController else { return nil }
        return makePageViewController(viewController.index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? BookPageViewController else { return nil }
        return makePageViewController(viewController.index + 1)
    }
}
