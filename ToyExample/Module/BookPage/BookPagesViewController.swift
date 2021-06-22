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
    
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        return pageViewController
    }()
    
    private var contents = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(light: .white, dark: .black)

        var pageStrings = [String]()

        for i in 1...11 {
            let contentString = "hello world: \(i)"
            pageStrings.append(contentString)
        }

        contents = pageStrings
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor)
        ])

        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let content = contents.first, let viewController = BookPageViewController.instance(0, content: content) {
            pageViewController.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
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
        var index: Int = 0
        if let viewController = viewController as? BookPageViewController {
            index = viewController.index - 1
        }
        guard let content = contents[safe: index] else { return nil }
        return BookPageViewController.instance(index, content: content)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index: Int = 0
        if let viewController = viewController as? BookPageViewController {
            index = viewController.index + 1
        }
        guard let content = contents[safe: index] else { return nil }
        return BookPageViewController.instance(index, content: content)
    }
}
