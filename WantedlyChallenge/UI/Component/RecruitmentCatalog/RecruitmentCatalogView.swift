//
//  RecruitmentCatalogView.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import DiffableDataSources
import ReactorKit
import RxOptional
import RxSwift
import UIKit

final class RecruitmentCatalogView: UIView {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(RecruitmentCollectionViewCell.self)
        }
    }

    private lazy var dataSource = CollectionViewDiffableDataSource<Section, CellItem>(
        collectionView: collectionView
        )
    { collectionView, indexPath, item -> UICollectionViewCell? in
        switch item {
        case let .recruitmentCellItem(recruitment):
            guard
                let cell = collectionView.dequeReusableCell(RecruitmentCollectionViewCell.self,
                                                            indexPath: indexPath)
                else {
                    return UICollectionViewCell()
            }
            cell.setCellContents(recruitment: recruitment)
            return cell
        }
    }

    var disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
        setCollectionViewLayout()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setCollectionViewLayout()
    }

    private func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.frame.width * 0.95,
                                 height: self.frame.height / 3)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}

extension RecruitmentCatalogView: StoryboardView {
    func bind(reactor: RecruitmentCatalogViewReactor) {
        Observable<Void>.just(())
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchBar.rx.text
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
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
                var snapshot = DiffableDataSourceSnapshot<Section, CellItem>()
                snapshot.appendSections([.recruitmentCatalog])
                snapshot.appendItems(page.collection, toSection: .recruitmentCatalog)
                snapshot.reloadSections([.recruitmentCatalog])
                self.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
    }
}
