//
//  ContentCollectionCell.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import UIKit

struct ContentCollectionCellConfiguration {
    var id: String
    var title: String
    var secondText: String
    var thirdText: String
    var imageURL: URL?
    
    fileprivate static var mock = ContentCollectionCellConfiguration( id: "", title: "", secondText: "", thirdText: "", imageURL: nil)
}

class ContentCollectionCell: UICollectionViewCell {
    var configuration: ContentCollectionCellConfiguration = .mock {
        didSet {
            configure()
        }
    }
    
    private lazy var imageLoader = ImageLoader(for: imageView)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let secondaryLabelsStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let thirdLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(resource: .colorSet1)
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(secondaryLabelsStackView)
        secondaryLabelsStackView.addArrangedSubview(secondaryLabel)
        secondaryLabelsStackView.addArrangedSubview(thirdLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            labelsStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            labelsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func configure() {        
        if let imageURL = configuration.imageURL {
            imageLoader.loadImage(from: imageURL)
        } else {
            imageView.image = nil
        }
        
        titleLabel.text = configuration.title
        secondaryLabel.text = configuration.secondText
        thirdLabel.text = configuration.thirdText
    }
}
