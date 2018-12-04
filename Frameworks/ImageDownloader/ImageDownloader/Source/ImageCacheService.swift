//
//  ImageCacheService.swift
//  ImageDownloader
//
//  Created by minsone on 04/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

import Foundation

protocol ImageCacheProtocol {
    var cache: NSCache<NSURL, UIImage> { get set }
    func loadFromCacheDisk(fileName: String) -> UIImage?
    func saveToCacheDisk(fileName: String, with image: UIImage)
}

class ImageCacheService: ImageCacheProtocol {
    var cache = NSCache<NSURL, UIImage>()
    static let shared = ImageCacheService()
    
    func loadFromCacheDisk(fileName: String) -> UIImage? {
        let paths = FileManager.default.urls(for: .cachesDirectory,
                                             in: .userDomainMask)
        if let filePath = paths.first?.appendingPathComponent(fileName),
            let image = UIImage(contentsOfFile: filePath.absoluteString) {
            return image
        } else {
            return nil
        }
    }
    
    func saveToCacheDisk(fileName: String, with image: UIImage) {
        let paths = FileManager.default.urls(for: .cachesDirectory,
                                             in: .userDomainMask)
        guard let filePath = paths.first?.appendingPathComponent(fileName),
            let data = image.pngData()
            else { return }
        try? data.write(to: filePath)
    }
}
