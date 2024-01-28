//
//  ImageLoader.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import UIKit

final class ImageLoader {
    
    private weak var imageView: UIImageView?
    
    private let cacheManager = DataCacheManager.shared
    
    private let activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.hidesWhenStopped = true
        return activityView
    }()
    
    private var currentRequest: URLSessionDataTask?
    private var currentURL: URL?
    
    init(for imageView: UIImageView) {
        self.imageView = imageView
        
        imageView.addSubview(activityView)
        
        NSLayoutConstraint.activate([
            activityView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
        activityView.stopAnimating()
    }
    
    func loadImage(from url: URL) {
        guard url != currentURL else { return }
        
        self.imageView?.image = nil
        currentRequest?.cancel()
        self.currentURL = url
        
        activityView.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let imageData = self?.cacheManager.fetchCachedData(forKey: url.urlAsKey),
               let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self?.setImageIfNeeded(image, for: url)
                }
            } else {
                self?.currentRequest = self?.fetchImage(from: url) { image in
                    guard let image else {
                        return
                    }
                    
                    if let data = image.jpegData(compressionQuality: 0.8) {
                        self?.cacheManager.cacheData(data, forKey: url.urlAsKey)
                    }
                    
                    DispatchQueue.main.async {
                        self?.setImageIfNeeded(image, for: url)
                    }
                }
            }
        }
        
    }
    
    private func fetchImage(from url: URL,
                            completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            completion(image)
        }
        
        self.currentRequest = dataTask
        
        dataTask.resume()
        
        return dataTask
    }
    
    private func setImageIfNeeded(_ image: UIImage?, for url: URL) {
        activityView.stopAnimating()
        
        if url == currentURL {
            imageView?.image = image
        }
    }
    
    deinit {
        currentRequest?.cancel()
    }
}

private extension URL {
    var urlAsKey: String {
        return self.absoluteString.filter { $0.isLetter || $0.isNumber }
    }
}
