//
//  ImageDownloader.swift
//  ImageDownloader
//
//  Created by minsone on 02/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

import Foundation
import FoundationExtension
import UIKit

public enum ImageDownloadError: Swift.Error {
    case 데이터없음
    case 네트워크에러(NSError)
}

private class ImageCache {
    var cache = NSCache<NSURL, UIImage>()
    static let shared = ImageCache()
    
    static func loadFromCacheDisk(fileName: String) -> UIImage? {
        let paths = FileManager.default.urls(for: .cachesDirectory,
                                             in: .userDomainMask)
        if let filePath = paths.first?.appendingPathComponent(fileName),
            let image = UIImage(contentsOfFile: filePath.absoluteString) {
            return image
        } else {
            return nil
        }
    }
    
    static func saveToCacheDisk(fileName: String, with image: UIImage) {
        let paths = FileManager.default.urls(for: .cachesDirectory,
                                             in: .userDomainMask)
        guard let filePath = paths.first?.appendingPathComponent(fileName),
            let data = image.pngData()
            else { return }
        try? data.write(to: filePath)
    }
}

public class ImageDownloader {
    let networking: URLSession

    init(networking: URLSession = URLSession.shared) {
        self.networking = networking
    }

    func download(url: URL, handler: ((URL, Result<UIImage, ImageDownloadError>) -> Void)? = nil) {
        if let cachedImage = ImageCache.shared.cache.object(forKey: url as NSURL) {
            handler?(url, .value(cachedImage))
            return
        }
        
        // TODO: DiskCache 구현 필요
        // Create path.
        if let cachedImage = ImageCache.loadFromCacheDisk(fileName: "\(url.absoluteString.hashValue)") {
            handler?(url, .value(cachedImage))
            return
        }

        let task = networking
            .dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    if let data = data,
                        let image = UIImage(data: data) {
                        ImageCache.shared.cache.setObject(image, forKey: url as NSURL)
                        ImageCache.saveToCacheDisk(fileName: "\(url.absoluteString.hashValue)", with: image)
                        handler?(url, .value(image))
                    } else if let error = error as NSError? {
                        handler?(url, .error(.네트워크에러(error)))
                    } else {
                        handler?(url, .error(.데이터없음))
                    }
                }
            }
        task.resume()
    }
}
