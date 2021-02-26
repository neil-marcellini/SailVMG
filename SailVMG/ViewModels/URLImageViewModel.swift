//
//  URLImageViewModel.swift
//  SailVMG
//
//  Created by Neil Marcellini on 2/24/21.
//

import Foundation
import SwiftUI

class URLImageViewModel: ObservableObject {
    var url: URL? = nil
    var imageCache = ImageCache.getImageCache()
    
    let imageCallback: (UIImage?)->()
    
    init(url: URL?, callback: @escaping (UIImage?)->()) {
        self.url = url
        imageCallback = callback
        loadImage()
    }
    
    
    func loadImage() {
        guard let url = url else {
            self.imageCallback(nil)
            return
        }
        if let cachedImage = imageCache.get(forKey: url.absoluteString){
            print("Cache hit")
            loadImageFromCache()
        } else {
            print("Cache miss, loading from url")
            loadImageFromURL()
        }
        
    }
    
    func loadImageFromCache() {
        guard let url = url else {
            self.imageCallback(nil)
            return
        }
        
        guard let cachedImage = imageCache.get(forKey: url.absoluteString) else {
            self.imageCallback(nil)
            return
        }
        self.imageCallback(cachedImage)
        
    }
    
    func loadImageFromURL() {
        guard let url = url else {
            self.imageCallback(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
            self.getImageFromResponse(data: data, response: res, error: error) { image in
                self.imageCallback(image)
            }
        }
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (UIImage?)->()) {
        guard error == nil else {
            print("Error: \(error!)")
            completion(nil)
            return
        }
        guard let data = data else {
            print("No data found")
            completion(nil)
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            
            self.imageCache.set(forKey: self.url!.absoluteString, image: loadedImage)
            completion(loadedImage)
        }
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
