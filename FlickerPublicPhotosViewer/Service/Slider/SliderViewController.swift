//
//  SliderViewController.swift
//  FlickerPublicPhotosViewer
//
//  Created by minsone on 03/12/2018.
//

import Foundation
import FoundationExtension
import UIKit
import UIKitExtension
import RxSwift
import ImageDownloader

class SliderViewController: UIViewController, StoryboardIdentifiable {
    @IBOutlet private(set) weak var firstImageContainView: UIView!
    @IBOutlet private(set) weak var firstImageView: UIImageView!
    @IBOutlet private(set) weak var secondImageContainView: UIView!
    @IBOutlet private(set) weak var secondImageView: UIImageView!
    
    lazy var imageViews: [UIImageView] = [firstImageView, secondImageView]
    
    typealias State = SliderViewReactor.State
    typealias Action = SliderViewReactor.Action
    
    var reactor: SliderViewReactor?
    
    let disposeBag = DisposeBag()
    
    lazy var backButton = {
        return UIBarButtonItem(barButtonSystemItem: .done,
                               target: nil,
                               action: nil)
    }()
    
    lazy var changeSliderShowDurationButton = {
        return UIBarButtonItem(title: "시간변경",
                               style: .done,
                               target: nil,
                               action: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindState()
        bindView()
        reactor?.action.onNext(.초기화)
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    private func setup() {
        navigationController?.hidesBarsOnTap = true
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = changeSliderShowDurationButton
    }
 
    private func bindState() {
        guard let reactor = reactor else { return }

        reactor.state
            .debug()
            .map { $0.currentSlider }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.updateSliderView(slider: $0)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.firstSliderURL }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak firstImageView]  in
                firstImageView?.download(url: $0)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.secondSliderURL }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak secondImageView] in
                secondImageView?.download(url: $0)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.animateDuration }
            .distinctUntilChanged()
            .flatMapLatest { duration -> Observable<Action> in
                return Observable<Int>
                    .interval(RxTimeInterval(duration),
                              scheduler: MainScheduler.instance)
                    .map { _ in Action.다음 }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindView() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    
        guard let reactor = self.reactor else { return }
        
        changeSliderShowDurationButton.rx.tap
            .map { Action.슬라이드쇼시간설정 }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func updateSliderView(slider: State.Slider) {
        let animateBlock: () -> Void = { [weak self] in
            self?.firstImageContainView.alpha = (slider == .first) ? 1 : 0
            self?.secondImageContainView.alpha = (slider == .second) ? 1 : 0
        }
        let completionBlock: (Bool) -> Void = { [weak self] _ in
            self?.firstImageContainView.isHidden = (slider == .first).not
            self?.secondImageContainView.isHidden = (slider == .second).not
            if (slider == .first).not {
                self?.firstImageView.image = nil
            }
            if (slider == .second).not {
                self?.secondImageView.image = nil
            }
            
        }
        UIView.animate(withDuration: 0.5, animations: animateBlock, completion: completionBlock)
    }
}
