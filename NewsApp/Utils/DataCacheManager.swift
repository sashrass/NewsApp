//
//  DataCacheManager.swift
//  NewsApp
//
//  Created by Alexandr Rassokhin on 28.01.2024.
//

import Foundation

final class DataCacheManager {
    static let shared = DataCacheManager()
    
    private var cache = NSCache<NSURL, NSData>()
    
    func cacheData(_ data: Data, forKey key: String) {
        guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(key) else {
            return
        }
        
        try? data.write(to: cacheURL)
    }
    
    func fetchCachedData(forKey key: String) -> Data? {
        if let url = NSURL(string: "com.NewsApp.DataCacheManager.\(key)"),
           let nsData = cache.object(forKey: url) {
            return Data(referencing: nsData)
        } else {
            guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(key) else {
                return nil
            }
            
            let data = try? Data(contentsOf: cacheURL)
            
            if let data = data as? NSData, let url = NSURL(string: "com.NewsApp.DataCacheManager.\(key)") {
                cache.setObject(data, forKey: url)
            }
            
            return data
        }
    }
}
