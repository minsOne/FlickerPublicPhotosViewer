//
//  Stortboard+Extension.swift
//  UIKitExtension
//
//  Created by minsone on 03/12/2018.
//  Copyright © 2018 kakaobank. All rights reserved.
//

import Foundation
import UIKit

public protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

public extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

public extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}
