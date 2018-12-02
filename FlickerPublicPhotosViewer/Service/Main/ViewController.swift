//
//  ViewController.swift
//  FlickerPublicPhotosViewer
//
//  Created by minsone on 02/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift


class ViewController: UIViewController {

    let reactor = MainViewReactor()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reactor.action.onNext(.초기화)
    }
    
    private func setup() {
        
    }
    
    private func bindState() {
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { isLoading in
                
            })
            .disposed(by: bag)
        
        reactor.state
            .map { $0.photos }
            .distinctUntilChanged()
            .subscribe(onNext: { photos in
                
            })
            .disposed(by: bag)
        
        reactor.state
            .map { $0.error }
            .filter { $0 != nil }
            .subscribe(onNext: { error in
                
            })
            .disposed(by: bag)
    }
    
    private func bindView() {
        
    }
}

