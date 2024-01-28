//
//  AllNewsListRouter.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import UIKit

class AllNewsListRouter: ContentListRoutingLogic {
    weak var vc: UIViewController?
    
    func navigateToContentDetails(with contentModel: ContentModel) {
        let viewController = ContentDetailsAssembly.buildFromAllNewsList(contentModel: contentModel)
        vc?.navigationController?.pushViewController(viewController, animated: true)
    }
}
