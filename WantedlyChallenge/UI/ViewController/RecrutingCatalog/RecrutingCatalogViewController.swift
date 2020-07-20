//
//  RecrutingCatalogViewController.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/18.
//  Copyright © 2020 Mori. All rights reserved.
//

import DiffableDataSources
import ReactorKit
import RxSwift
import UIKit

final class RecrutingCatalogViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(RecrutingCollectionViewCell.self)
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.view.frame.width * 0.9,
                                     height: self.view.frame.height / 4)
            collectionView.setCollectionViewLayout(layout, animated: true)
        }
    }

    private lazy var dataSource = CollectionViewDiffableDataSource<Section, CellItem>(
        collectionView: collectionView
        )
    { collectionView, indexPath, item -> UICollectionViewCell? in
        switch item {
        case let .recruitmentCellItem(recruitment):
            guard
                let cell = collectionView.dequeReusableCell(RecrutingCollectionViewCell.self,
                                                            indexPath: indexPath)
                else {
                    return UICollectionViewCell()
            }
            return cell
        }
    }

    private var snapshot = DiffableDataSourceSnapshot<Section, CellItem>()

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        snapshot.appendSections([.recruitmentCatalog])
        func setUpRx() {

        }
    }
}

extension RecrutingCatalogViewController: View {
    func bind(reactor: RecrutingCatalogViewReactor) {
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchBar.rx.text
            .map(Reactor.Action.search)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        collectionView.rx.isReachedBottom
            .map { [weak self] _ in self?.searchBar.text }
            .map(Reactor.Action.paginate)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.page }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] page in
                guard let self = self else {
                    return
                }
                self.snapshot.appendItems(page.collection)
                self.dataSource.apply(self.snapshot)
            })
            .disposed(by: disposeBag)
    }
}
