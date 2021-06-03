//
//  ShadowViewController.swift
//

import UIKit

class ShadowViewController: BaseViewController {
    static func instance() -> ShadowViewController? {
        return ShadowViewController()
    }

    private var shadowView: ShadowView = {
        let view = ShadowView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.shadowColor = UIColor(light: .black, dark: .white)
        view.fillColor = UIColor(light: .black, dark: .white)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(light: .white, dark: .black)

        view.addSubview(shadowView)

        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor, constant: -20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: shadowView.topAnchor, constant: -20),
            shadowView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
