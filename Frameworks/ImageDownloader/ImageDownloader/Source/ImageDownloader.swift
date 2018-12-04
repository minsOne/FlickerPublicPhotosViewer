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

public class ImageDownloader {
    let networking: URLSession
    let imageCacheService: ImageCacheProtocol

    init(networking: URLSession = URLSession.shared,
         imageCacheService: ImageCacheProtocol = ImageCacheService.shared) {
        self.networking = networking
        self.imageCacheService = imageCacheService
    }

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
            .dataTask(with: url) { data, _, error in
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
