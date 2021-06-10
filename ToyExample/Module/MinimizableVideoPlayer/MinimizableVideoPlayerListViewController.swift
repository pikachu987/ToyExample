//
//  MinimizableVideoPlayerListViewController.swift
//  ToyExample
//
//  Created by corpdocfriends on 2021/06/03.
//

import UIKit

class MinimizableVideoPlayerListViewController: BaseViewController {
    static func instance() -> MinimizableVideoPlayerListViewController? {
        return MinimizableVideoPlayerListViewController()
    }

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MinimizableVideoPlayerListCell.self, forCellReuseIdentifier: MinimizableVideoPlayerListCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var items = [MinimizableVideo]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchData()
    }
    
    private func fetchData() {
        guard let url = Bundle.main.url(forResource: "MinimizableVideo", withExtension: "json") else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let items = try? JSONDecoder().decode([MinimizableVideo].self, from: data) else { return }
        self.items = items
    }
}

// MARK: UITableViewDelegate
extension MinimizableVideoPlayerListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = items[safe: indexPath.row] else { return }
        (navigationController?.tabBarController as? MinimizableVideoPlayerListTabbarController)?.showPlayerVideo(item)
    }
}

// MARK: UITableViewDataSource
extension MinimizableVideoPlayerListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MinimizableVideoPlayerListCell.identifier, for: indexPath) as? MinimizableVideoPlayerListCell else { fatalError() }
        cell.delegate = self
        cell.item = items[safe: indexPath.row]
        return cell
    }
}

// MARK: MinimizableVideoPlayerListCellDelegate
extension MinimizableVideoPlayerListViewController: MinimizableVideoPlayerListCellDelegate {
    func minimizableVideoPlayerListCellThumbImage(_ thumb: String?, closure: (((thumb: String?, image: UIImage?)) -> Void)?) {
        if let thumb = thumb, let thumbURL = URL(string: thumb) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: thumbURL) {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        closure?((thumb: thumb, image: image))
                    }
                } else {
                    DispatchQueue.main.async {
                        closure?((thumb: thumb, image: nil))
                    }
                }
            }
        } else {
            closure?((thumb: thumb, image: nil))
        }
    }
}
