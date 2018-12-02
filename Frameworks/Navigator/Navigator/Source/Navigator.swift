//
//  Navigator.swift
//  Navigator
//
//  Created by JungMinAhn on 30/11/2018.
//  Copyright © 2018 kakaobank. All rights reserved.
//

import Foundation
import UIKit

enum Navigator {}

extension Navigator {
    enum Push {}
    enum Pop {}
    enum Present {}
    enum Dismiss {}
}

extension Navigator {
    private static var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }

    private static func recursivelyPresentedViewController(from viewControler: UIViewController) -> UIViewController {
        if let presentedViewController = viewControler.presentedViewController {
            return recursivelyPresentedViewController(from: presentedViewController)
        }
        return viewControler
    }
}

extension Navigator.Push {
    static func viewController(_ viewController: UIViewController, animated: Bool = true) {
        guard let rootViewController = Navigator.rootViewController else { return }
        let currentViewController = Navigator.recursivelyPresentedViewController(from: rootViewController)
        currentViewController
            .navigationController?
            .pushViewController(viewController,
                                animated: animated)
    }
}

extension Navigator.Present {
    static func viewController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        guard let rootViewController = Navigator.rootViewController else { return }
        let currentViewController = Navigator.recursivelyPresentedViewController(from: rootViewController)

        currentViewController.present(viewController,
                                      animated: animated,
                                      completion: completion)
    }
    
    static func navigationViewController(root viewController: UIViewController, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        guard let rootViewController = Navigator.rootViewController else { return }
        let currentViewController = Navigator.recursivelyPresentedViewController(from: rootViewController)

        let naviViewController = UINavigationController(rootViewController: viewController)
        currentViewController.present(naviViewController,
                                      animated: animated,
                                      completion: completion)
    }
}
