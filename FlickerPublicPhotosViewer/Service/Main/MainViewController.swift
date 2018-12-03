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
import RxCocoa
import Navigator

final class MainViewController: UIViewController {

    @IBOutlet private(set) weak var startButton: UIButton!

    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    private func setup() {
    }
    
    private func bindView() {
        startButton.rx.tap
            .asDriver()
            .map { SliderViewBuilder().build() }
            .drive(onNext: {
                Navigator.Present
                    .navigationViewController(root: $0,
                                              animated: true,
                                              completion: nil)
            })
            .disposed(by: bag)
    }
}
