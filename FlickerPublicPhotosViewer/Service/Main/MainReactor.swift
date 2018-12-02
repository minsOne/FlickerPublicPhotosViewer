//
//  MainReactor.swift
//  FlickerPublicPhotosViewer
//
//  Created by minsone on 02/12/2018.
//  Copyright © 2018 minsone. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum MainReactorable {
    enum Action {
        case 초기화
    }
    
    struct State {
        var isLoading: Bool
        var photos: [URL?]
        var error: Error?
    }
}

class MainViewReactor: Reactor {
    typealias Action = MainReactorable.Action
    typealias State = MainReactorable.State
    
    typealias PhotoPublicResponse = API.Service.Feeds.PhotoPublicResponse
    
    enum Mutation {
        case 로딩중, 로딩완료
        case 이미지목록(PhotoPublicResponse)
        case 에러(Error)
    }
    
    struct Model {
        var response: API.Service.Feeds.PhotoPublicResponse? = nil
    }
    
    let initialState: State
    var model: Model

    init() {
        model = Model()

        initialState = State(isLoading: false,
                             photos: [],
                             error: nil)
    }
    
    func mutate(action: MainReactorable.Action) -> Observable<Mutation> {
        switch action {
        case .초기화: return initialize()
        }
    }
    
    func reduce(state: MainReactorable.State, mutation: MainViewReactor.Mutation) -> MainReactorable.State {
        var newState = state
        newState.error = nil
        
        switch mutation {
        case .로딩중:
            newState.isLoading = true
        case .로딩완료:
            newState.isLoading = false
        case .이미지목록(let resp):
            model.response = resp
            newState.photos = resp.feed.entry.map { $0.thumbnameImageURL }
            break
        case .에러(let err):
            newState.error = err
        }
        
        return newState
    }
    
    private func initialize() -> Observable<Mutation> {
        let requestObservable = API.Service.Feeds.PhotosPublic()
            .requestObservable()
            .map { Mutation.이미지목록($0) }
        
        var mutations: [Observable<Mutation>] = []
        mutations.append(.just(.로딩중))
        mutations.append(requestObservable)
        mutations.append(.just(.로딩완료))
        
        return Observable.concat(mutations)
    }
}


