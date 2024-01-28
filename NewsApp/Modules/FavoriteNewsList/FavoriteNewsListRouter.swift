//
//  FavoriteNewsListRouter.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import UIKit

class FavoriteNewsListRouter: ContentListRoutingLogic {
    weak var vc: UIViewController?
    
    func navigateToContentDetails(with contentModel: ContentModel) {
        let viewController = ContentDetailsAssembly.buildFromFavoriteNewsList(contentModel: contentModel)
        vc?.navigationController?.pushViewController(viewController, animated: true)
    }
}
