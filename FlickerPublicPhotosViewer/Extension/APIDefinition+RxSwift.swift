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
    func requestObservable<R: ResponseDataTypeProtocol>() -> Observable<R> {
        return Observable.create { observer -> Disposable in
            self.request(completion: { (result) in
                switch result {
                case .value(let v):
                    if let v = v as? R {
                        observer.onNext(v as R)
                    }
                    observer.onCompleted()
                case .error(let e):
                    observer.onError(e)
                }
            })
            
            return Disposables.create()
        }
    }
}
