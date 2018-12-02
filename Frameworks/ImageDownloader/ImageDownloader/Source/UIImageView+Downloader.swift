//
//  UIImageView+Downloader.swift
//  ImageDownloader
//
//  Created by minsone on 02/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

import Foundation
import FoundationExtension
import UIKit

public extension UIImageView {
    func download(url: URL?, handler: ((Result<(URL, UIImage), ImageDownloadError>) -> Void)? = nil) {
        guard let url = url else {
            self.image = nil
            return
        }
        
        let completionHandler: (Result<(URL, UIImage), ImageDownloadError>) -> Void
        
        if let handler = handler {
            completionHandler = handler
        } else {
            completionHandler = { [weak self] result in
                switch result {
                case .value(let (_, image)):
                    self?.image = image
                case .error:
                    self?.image = nil
                }
            }
        }
        
        ImageDownloader().download(url: url, handler: completionHandler)
    }
}
