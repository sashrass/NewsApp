//
//  ContentDetailsViewController.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import UIKit

class ContentDetailsViewController: UIViewController {
    
    var vm: ContentDetailsViewModel!
    
    private let contentView = ContentDetailsView()
    
    private var favoriteButtonImage: UIImage? {
        vm.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        contentView.configuration = vm.contentConfiguration
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: favoriteButtonImage,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didSelectFavoriteButton))
    }
    
    @objc
    private func didSelectFavoriteButton() {
        vm.didSelectFavoriteButton()
    }
    
    deinit {
        print("deinit")
    }
}

extension ContentDetailsViewController: ContentDetailsViewModelOutput {
    func isFavoriteStatusDidChange() {
        navigationItem.rightBarButtonItem?.image = favoriteButtonImage
    }
}
