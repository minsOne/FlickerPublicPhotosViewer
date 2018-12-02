//
//  API+ServiceFeedsPhotosPublic.swift
//  FlickerPublicPhotosViewer
//
//  Created by minsone on 02/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

import Foundation
import APIDefinition
import XMLParsing

extension API.Service.Feeds {
    struct PhotosPublic: APIDefinition {
        var method: HTTPMethod { return .GET }

        var path: String {
            return "/services/feeds/photos_public.gne"
        }

        typealias Response = PhotoPublicResponse
    }

    struct PhotoPublicResponse: ResponseDataTypeProtocol {
        struct Feeds: Decodable {
            struct Link: Decodable {
                let rel: String
                let href: URL
            }
            struct Entry: Decodable {
                let published: String
                let updated: String
                let link: [Link]
                var thumbnameImageURL: URL? {
                    return link.first?.href
                }
                var largeImageURL: URL? {
                    return link.last?.href
                }
            }
            var title: String
            var entry: [Entry]
        }
        
        var feed: Feeds
    
        init?(data: Data) {
            let decoder = XMLDecoder()
            if let result = try? decoder.decode(Feeds.self, from: data) {
                feed = result
            } else {
                return nil
            }
        }
    }
}

