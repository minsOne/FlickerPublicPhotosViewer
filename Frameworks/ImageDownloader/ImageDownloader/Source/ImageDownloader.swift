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
import APIDefinition

public enum ImageDownloadError: Swift.Error {
    case 데이터없음
    case 네트워크에러(NSError)
}

protocol ImageDownloaderProtocol {
    var networking: NetworkingProtocol { get }
    var imageCacheService: ImageCacheProtocol { get }
}

extension ImageDownloaderProtocol {
    var networking: NetworkingProtocol {
        return URLSession.shared
    }
    var imageCacheService: ImageCacheProtocol {
        return ImageCacheService.shared
    }
}

public class ImageDownloader: ImageDownloaderProtocol {
    init() {}

    func download(url: URL, handler: ((URL, Result<UIImage, ImageDownloadError>) -> Void)? = nil) {
        let imageCacheService = self.imageCacheService

        if let cachedImage = imageCacheService.cache.object(forKey: url as NSURL) {
            handler?(url, .value(cachedImage))
            return
        }
        
        // TODO: DiskCache 구현 필요
        // Create path.
        if let cachedImage = imageCacheService.loadFromCacheDisk(fileName: "\(url.absoluteString.hashValue)") {
            handler?(url, .value(cachedImage))
            return
        }
  
        let task = networking
            .dataTask(with: .init(url: url)) { data, _, error in
                DispatchQueue.main.async {
                    if let data = data,
                        let image = UIImage(data: data) {
                        imageCacheService.cache.setObject(image, forKey: url as NSURL)
                        imageCacheService.saveToCacheDisk(fileName: "\(url.absoluteString.hashValue)", with: image)
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
