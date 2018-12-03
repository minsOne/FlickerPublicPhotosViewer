//
//  APIDefinition+RxSwift.swift
//  FlickerPublicPhotosViewer
//
//  Created by minsone on 02/12/2018.
//

import APIDefinition
import FoundationExtension
import RxSwift

extension APIDefinition {
    func requestObservable() -> Observable<Response> {
        return Observable.create { observer -> Disposable in
            self.request(completion: { (result) in
                switch result {
                case .value(let v):
                    observer.onNext(v)
                    observer.onCompleted()
                case .error(let e):
                    observer.onError(e)
                }
            })
            
            return Disposables.create()
        }
    }
}
