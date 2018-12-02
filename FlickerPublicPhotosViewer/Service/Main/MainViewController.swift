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

final class MainViewController: UIViewController {

    @IBOutlet private(set) weak var collectionView: UICollectionView!
    
    let reactor = MainViewReactor()
    let bag = DisposeBag()
    
    private var collectionShim: MainViewCollectionViewShim?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindState()
        bindView()
        reactor.action.onNext(.초기화)
    }
    
    private func setup() {
        self.collectionShim = .init(collectionView: collectionView)
    }
    
    private func bindState() {
        reactor.state
            .map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: { isLoading in
                print(isLoading)
            })
            .disposed(by: bag)
        
        reactor.state
            .map { $0.photos }
            .distinctUntilChanged()
            .subscribe(onNext: { photos in
                print(photos)
            })
            .disposed(by: bag)
        
        reactor.state
            .map { $0.error }
            .filter { $0 != nil }
            .subscribe(onNext: { error in
                print(error)
            })
            .disposed(by: bag)
    }
    
    private func bindView() {
        
    }
}


private class MainViewCollectionViewShim: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    private var dataSource: [URL?] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewThumbnailImageCollectionViewCell", for: indexPath) as? MainViewThumbnailImageCollectionViewCell {
            return cell
        }
        return MainViewThumbnailImageCollectionViewCell()
    }
    
    weak var collectionView: UICollectionView?
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

private class MainViewThumbnailImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private(set) weak var imageView: UIImageView!

    private var imageURL: URL? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageURL = nil
    }
    
    func setImageURL(_ url: URL?) {
        
    }
}
