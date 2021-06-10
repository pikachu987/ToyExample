//
//  MinimizableVideoPlayerListCell.swift
//  ToyExample
//
//  Created by GwanhoKim on 2021/06/03.
//

import UIKit

protocol MinimizableVideoPlayerListCellDelegate: AnyObject {
    func minimizableVideoPlayerListCellThumbImage(_ thumb: String?, closure: (((thumb: String?, image: UIImage?)) -> Void)?)
}

class MinimizableVideoPlayerListCell: UITableViewCell {
    weak var delegate: MinimizableVideoPlayerListCellDelegate?

    static let identifier = "MinimizableVideoPlayerListCell"
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 752), for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .right
        label.textColor = UIColor(light: 150/255, dark: 170/255)
        return label
    }()
    
    var item: MinimizableVideo? {
        didSet {
            delegate?.minimizableVideoPlayerListCellThumbImage(item?.thumb, closure: { [weak self] (thumb: String?, image: UIImage?) in
                if thumb == self?.item?.thumb {
                    self?.thumbnailImageView.image = image
                    self?.thumbnailImageView.backgroundColor = image == nil ? .gray : .white
                }
            })
            titleLabel.text = item?.title
            subtitleLabel.text = item?.subtitle
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            thumbnailImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -12),
            contentView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.topAnchor),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor),
            subtitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 64),
            contentView.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbnailImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
}
