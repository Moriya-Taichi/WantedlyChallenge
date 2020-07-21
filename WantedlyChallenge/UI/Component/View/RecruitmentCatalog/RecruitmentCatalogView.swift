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

    private let activityIndicator = UIActivityIndicatorView()

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

    private let selectedCellSubject = PublishSubject<Int>()
    var selectedCellStream: Observable<Int> {
        return selectedCellSubject
    }

    var disposeBag = DisposeBag()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
        setCollectionViewLayout()
        setupActivityIndicator()
        setupRx()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setCollectionViewLayout()
        setupActivityIndicator()
        setupRx()
    }

    private func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.frame.width * 0.95,
                                 height: self.frame.height / 3)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    private func setupActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(
            red: 17 / 255,
            green: 146 / 255,
            blue: 196 / 255,
            alpha: 1
        )
        addSubview(activityIndicator)
    }

    private func setupRx() {
        collectionView.rx.itemSelected
            .subscribe(onNext: {[weak self] indexPath in
                guard
                    case let .recruitmentCellItem(recruitment) = self?.reactor?.currentState.page.collection[indexPath.row]
                    else
                {
                    return
                }
                self?.selectedCellSubject.onNext(recruitment.id)
            })
            .disposed(by: disposeBag)
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

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
}
