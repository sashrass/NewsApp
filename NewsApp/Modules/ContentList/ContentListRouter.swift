//
//  ContentListRouter.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 27.01.2024.
//

import UIKit

class ContentListRouter: ContentListRoutingLogic {
    weak var vc: UIViewController?
    
    func navigateToContentDetails(model: ContentModelProtocol) {
        let viewController = ContentDetailsAssembly.build(contentModel: model)
        vc?.navigationController?.pushViewController(viewController, animated: true)
    }
}
