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
}

public class ImageDownloader {
    let networking: URLSession

    init(networking: URLSession = URLSession.shared) {
        self.networking = networking
    }

    func download(url: URL, handler: ((Result<(URL, UIImage), ImageDownloadError>) -> Void)? = nil) {
        if let cachedImage = ImageCache.shared.cache.object(forKey: url as NSURL) {
            handler?(.value((url, cachedImage)))
            return
        }
        
        // TODO: DiskCache 구현 필요

        let task = networking
            .dataTask(with: url) { data, _, error in
                if let data = data,
                    let image = UIImage(data: data) {
                    ImageCache.shared.cache.setObject(image, forKey: url as NSURL)
                    handler?(.value((url, image)))
                } else if let error = error as NSError? {
                    handler?(.error(.네트워크에러(error)))
                } else {
                    handler?(.error(.데이터없음))
                }
            }
        task.resume()
    }
}
