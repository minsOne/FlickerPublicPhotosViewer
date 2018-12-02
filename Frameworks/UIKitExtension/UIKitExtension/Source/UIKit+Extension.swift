//
//  UIKit+Extension.swift
//  UIKitExtension
//
//  Created by JungMinAhn on 30/11/2018.
//  Copyright © 2018 kakaobank. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = self.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            return self.layer.borderWidth = newValue
        }
    }
}
