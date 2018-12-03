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
        
        startButton.addTarget(self, action: #selector(tappedStartButton), for: .touchUpInside)
    }
    
    @objc func tappedStartButton() {
        let vc: SliderViewController = UIStoryboard.slider.instantiateViewController()
        
        vc.reactor = SliderViewReactor()

        Navigator.Present.navigationViewController(root: vc, animated: true, completion: nil)
    }
}
    
//    private func setup() {
//        self.collectionShim = .init(collectionView: collectionView)
//    }
//
//    private func bindState() {
//        reactor.state
//            .map { $0.isLoading }
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak loadingIndicator] isLoading in
//                isLoading
//                    ? loadingIndicator?.startAnimating()
//                    : loadingIndicator?.stopAnimating()
//            })
//            .disposed(by: bag)
//
//        reactor.state
//            .map { $0.photos }
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak collectionShim] photos in
//                collectionShim?.updateDataSource(photos)
//            })
//            .disposed(by: bag)
//
//        reactor.state
//            .map { $0.error }
//            .filter { $0 != nil }
//            .subscribe(onNext: { error in
//                print(error)
//            })
//            .disposed(by: bag)
//    }
//
//    private func bindView() {
//
//    }
//}
//
//
//fileprivate class MainViewCollectionViewShim: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
//    weak var collectionView: UICollectionView?
//    private var dataSource: [URL?] = []
//
//    init(collectionView: UICollectionView) {
//        self.collectionView = collectionView
//        super.init()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//
//    func updateDataSource(_ source: [URL?]) {
//        self.dataSource = source
//        self.collectionView?.reloadData()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataSource.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewThumbnailImageCollectionViewCell", for: indexPath) as? MainViewThumbnailImageCollectionViewCell {
//            guard let url = dataSource[safe: indexPath.row] else { return cell }
//            cell.setImageURL(url)
//            return cell
//        }
//        return MainViewThumbnailImageCollectionViewCell()
//    }
//}
//
//import ImageDownloader
//
//final class MainViewThumbnailImageCollectionViewCell: UICollectionViewCell {
//    @IBOutlet private(set) weak var imageView: UIImageView!
//    @IBOutlet private(set) weak var loadingIndicatorView: UIActivityIndicatorView!
//
//    private var imageURL: URL? = nil
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        imageView.image = nil
//        imageURL = nil
//        loadingIndicatorView.stopAnimating()
//    }
//
//    func setImageURL(_ url: URL?) {
//        self.imageURL = url
//
//        loadingIndicatorView.startAnimating()
//        self.imageView.download(url: url) { [weak self, weak loadingIndicatorView] (resultUrl, result) in
//            guard let self = self,
//                resultUrl == url
//                else { return }
//
//            defer {
//                loadingIndicatorView?.stopAnimating()
//            }
//
//            switch result {
//            case .value(let image):
//                self.imageView.image = image
//            case .error:
//                self.imageView.image = nil
//            }
//        }
//    }
//}
