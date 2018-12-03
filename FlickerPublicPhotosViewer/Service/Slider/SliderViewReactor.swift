//
//  SliderViewReactor.swift
//  FlickerPublicPhotosViewer
//
//  Created by minsone on 03/12/2018.
//

import Foundation
import ReactorKit
import RxSwift
import UIKit
import DifferenceKit

enum SliderReactoable {
    enum Action {
        case 초기화
        case 다음
        case 슬라이드쇼시간설정
        case 나가기
    }
    
    struct State {
        static let defaultAnimateDuration: CGFloat = 5
        
        enum Slider {
            case first, second
        }
        var currentSlider: Slider
        var firstSliderURL: URL?
        var secondSliderURL: URL?
        var animateDuration: CGFloat
    }
}

class SliderViewReactor: Reactor {
    typealias Action = SliderReactoable.Action
    typealias State = SliderReactoable.State
    
    enum Mutation {
        case 초기이미지목록([URL])
        case 추가이미지목록([URL])
        case 다음슬라이드
        case 나가기
        case 슬라이드쇼시간설정(CGFloat)
    }
    
    struct Model {
        var photosURLs: [URL]
        var currentIndex: Int
    }
    
    let initialState: State
    var model: Model
    
    private let imageListSubject = PublishSubject<[URL]>()
    let disposeBag = DisposeBag()
    
    init() {
        self.model = .init(photosURLs: [],
                           currentIndex: -1)
        self.initialState = .init(currentSlider: .first,
                                  firstSliderURL: nil,
                                  secondSliderURL: nil,
                                  animateDuration: State.defaultAnimateDuration)
        
        Observable<Int>.interval(60.0, scheduler: MainScheduler.instance)
            .flatMapLatest { _ in API.Service.Feeds.PhotosPublic()
                .requestObservable()
                .map { $0.feed.entry.compactMap { $0.largeImageURL } }
                .catchErrorJustReturn([])
            }
            .debug()
            .bind(to: imageListSubject)
            .disposed(by: disposeBag)
    }
    
    func mutate(action: SliderReactoable.Action) -> Observable<SliderViewReactor.Mutation> {
        switch action {
        case .초기화:
            return initialize()
        case .다음:
            return .just(.다음슬라이드)
        case .슬라이드쇼시간설정:
            return .just(.슬라이드쇼시간설정(5))
        case .나가기:
            return .just(.나가기)
        }
    }
    
    func transform(mutation: Observable<SliderViewReactor.Mutation>) -> Observable<SliderViewReactor.Mutation> {
//        return Observable.merge(imageListSubject.map { Mutation.추가이미지목록($0) }, mutation)
        return mutation
    }
    
    func reduce(state: SliderReactoable.State, mutation: SliderViewReactor.Mutation) -> SliderReactoable.State {
        var newState = state
        
        switch mutation {
        case .초기이미지목록(let urls):
            model.photosURLs = urls
            model.currentIndex = 0

            newState.currentSlider = .first
            newState.firstSliderURL = urls[safe: 0]
            newState.secondSliderURL = urls[safe: 1]
        case .추가이미지목록(let urls):
            let changeset = StagedChangeset(source: model.photosURLs, target: urls)
            let insertedURLs = changeset.map { $0.elementInserted }
                .flatMap { $0 }
                .map { $0.element }
                .compactMap { urls[safe: $0] }
            model.photosURLs.append(contentsOf: insertedURLs)

        case .다음슬라이드:
            model.currentIndex += 1
            let nextIndex = model.currentIndex
            let urls = model.photosURLs
            
            switch newState.currentSlider {
            case .first:
                newState.currentSlider = .second
                newState.firstSliderURL = urls[safe: nextIndex+1]
            case .second:
                newState.currentSlider = .first
                newState.secondSliderURL = urls[safe: nextIndex+1]
            }
            
        case .슬라이드쇼시간설정(let duration):
            newState.animateDuration = duration
        case .나가기: break
        }
        
        return newState
    }
    
    private func initialize() -> Observable<Mutation> {
        return API.Service.Feeds.PhotosPublic()
            .requestObservable()
            .map { resp -> [URL] in
                return resp.feed.entry.compactMap { $0.largeImageURL }
            }
            .map { Mutation.초기이미지목록($0) }
    }
}

extension URL: Differentiable {}
