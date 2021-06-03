//
//  TransparentViewController.swift
//

import UIKit

class TransparentViewController: BaseViewController {
    static func instance() -> TransparentViewController? {
        return TransparentViewController()
    }

    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private let sizeSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 4
        slider.maximumValue = 40
        slider.value = 16
        return slider
    }()

    private var transparentView: TransparentView = {
        let view = TransparentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = UIColor(light: .white, dark: .black)
        view.gray = UIColor(light: 192/255, dark: 66/255)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(light: .white, dark: .black)

        view.addSubview(sizeLabel)
        view.addSubview(sizeSlider)
        view.addSubview(transparentView)

        NSLayoutConstraint.activate([
            sizeSlider.leadingAnchor.constraint(equalTo: sizeLabel.leadingAnchor).identifier("sizeSliderLeading"),
            sizeSlider.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor),
            sizeLabel.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: sizeSlider.leadingAnchor, constant: -20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: sizeSlider.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: sizeSlider.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            sizeSlider.bottomAnchor.constraint(equalTo: transparentView.topAnchor, constant: -20),
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: -20),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: 20),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor, constant: 20),
        ])
        
        sizeSlider.addTarget(self, action: #selector(sizeValueChanged(_:)), for: .valueChanged)
        sizeSlider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sizeTapGesture(_:))))
        
        DispatchQueue.main.async {
            self.updateSize()
        }
    }
    
    override func orientationDidChangeDetect(_ notification: Notification) {
        super.orientationDidChangeDetect(notification)
        
    }
    
    @objc private func sizeValueChanged(_ sender: UISlider) {
        updateSize()
    }
    
    @objc private func sizeTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        let pointTapped = gestureRecognizer.location(in: view)
        let positionOfSlider = sizeSlider.frame.origin
        let widthOfSlider = sizeSlider.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(sizeSlider.maximumValue) / widthOfSlider)
        sizeSlider.setValue(Float(newValue), animated: false)
        updateSize()
    }
    
    private func updateSize() {
        transparentView.size = CGFloat(sizeSlider.value)
        sizeLabel.text = String(format: "%.1f", sizeSlider.value)
        let percentage = CGFloat((sizeSlider.value - sizeSlider.minimumValue) / (sizeSlider.maximumValue - sizeSlider.minimumValue))
        let xPoint = ((sizeSlider.bounds.width - sizeLabel.bounds.width) * percentage)
        view.constraints.filter({ $0.identifier == "sizeSliderLeading" }).first?.constant = -xPoint
    }
}
