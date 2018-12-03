//
//  AlertPrompt.swift
//  FlickerPublicPhotosViewer
//
//  Created by minsone on 04/12/2018.
//

import Foundation
import UIKit
import RxSwift


protocol NumberPromptServiceProtocol {
    var title: String { get }
    var message: String { get }

    var completion: (Int?) -> Void { get set }
    
    var viewController: UIAlertController { get }
}

class NumberPromptService: NumberPromptServiceProtocol {
    var completion: (Int?) -> Void = { _ in }
    
    let title = "슬라이드쇼 시간 입력"
    let message = "시간(초)을 입력해주세요."
    
    let viewController: UIAlertController
    
    init() {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        self.viewController = alert
        
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "10"
            textField.keyboardType = .numberPad
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: { [weak self] _ in
            self?.completion(nil)
        })
        
        let confirmAction = UIAlertAction(title: "적용", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            if let text = self?.viewController.textFields?[safe: 0]?.text {
                self?.completion(Int(text))
            } else {
                self?.completion(nil)
            }
        })
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
    }
}
