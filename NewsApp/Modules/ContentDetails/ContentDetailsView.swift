//
//  ContentDetailsView.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import UIKit

struct ContentDetailsViewConfiguration {
    var imageURL: URL?
    var descriptionText: String
    var secondaryText: String
    var thirdText: String
    
    
    fileprivate static var mock = ContentDetailsViewConfiguration(imageURL: nil, descriptionText: "", secondaryText: "", thirdText: "")
}

class ContentDetailsView: UIView {
    var configuration: ContentDetailsViewConfiguration = .mock {
        didSet {
            configure()
        }
    }
    
    private lazy var imageLoader = ImageLoader(for: imageView)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let thirdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
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
        backgroundColor = .systemBackground
        
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(labelsStackView)
        labelsStackView.addArrangedSubview(descriptionLabel)
        labelsStackView.addArrangedSubview(secondaryLabel)
        labelsStackView.addArrangedSubview(thirdLabel)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35),
            
            labelsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            labelsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            labelsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            labelsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
        ])
    }
    
    private func configure() {
        if let imageURL = configuration.imageURL {
            imageLoader.loadImage(from: imageURL)
        } else {
            imageView.image = nil
        }
        
        descriptionLabel.text = configuration.descriptionText
        secondaryLabel.text = configuration.secondaryText
        thirdLabel.text = configuration.thirdText
    }
}
