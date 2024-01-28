//
//  StoredContentManager.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import Foundation

private enum ContentUpdateEventType {
    case added(ContentModel)
    case deleted(ContentModel)
}

class StoredContentManager {
    
    private static var sharedStoredContent: [ContentModel] = {
        let news = ContentStorageService().getContent()
        return news
    }()
    
    private(set) var contentList: [ContentModel] {
        get {
            StoredContentManager.sharedStoredContent
        } set {
            StoredContentManager.sharedStoredContent = newValue
        }
    }
    
    private let storageService = ContentStorageService()
    
    var contentAddedHandler: ((ContentModel) -> Void)?
    var contentDeletedHandler: ((ContentModel) -> Void)?
    
    init() {
        setupNotifications()
    }
    
    func addContent(_ content: ContentModel) {
        guard !contentList.contains(where: { content.id == $0.id }) else {
            return
        }
        
        storageService.addContent([content])
        contentList.insert(content, at: 0)
        sendNotification(eventType: .added(content))
    }
    
    func deleteContent(_ content: ContentModel) {
        guard contentList.contains(where: { content.id == $0.id }) else {
            return
        }
        
        storageService.deleteContent([content])
        contentList.removeAll(where: { $0.id == content.id })
        sendNotification(eventType: .deleted(content))
    }
    
    func fetchContent(by id: String) -> ContentModel? {
        guard let content = contentList.first(where: { $0.id == id }) else { return nil }
        return content
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiveNotificaiton),
                                               name: .contentUpdated,
                                               object: nil)
    }
    
    private func sendNotification(eventType: ContentUpdateEventType) {
        NotificationCenter.default.post(name: .contentUpdated, object: nil, userInfo: [eventTypeKey: eventType])
    }
    
    @objc
    private func didReceiveNotificaiton(notification: NSNotification) {
        guard let eventType = notification.userInfo?[eventTypeKey] as? ContentUpdateEventType else {
            return
        }
        
        switch eventType {
        case .added(let contentModel):
            contentAddedHandler?(contentModel)
            
        case .deleted(let contentModel):
            contentDeletedHandler?(contentModel)
        }
    }
}

private let eventTypeKey = "eventType"
extension Notification.Name {
    fileprivate static let contentUpdated = Notification.Name(rawValue: "StoredContentManager_contentUpdated")
}
