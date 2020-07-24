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

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(RecruitmentCollectionViewCell.self)
        }
    }

    let refreshControl = UIRefreshControl()

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
        default:
            return UICollectionViewCell()
        }
    }

    private let selectedCellSubject = PublishSubject<Int>()
    var selectedCellStream: Observable<Int> {
        return selectedCellSubject
    }

    var disposeBag = DisposeBag()
    let searchController = UISearchController()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
        setCollectionViewLayout()
        setupActivityIndicator()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setCollectionViewLayout()
        setupActivityIndicator()
        searchController.obscuresBackgroundDuringPresentation = false
    }

    private func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.frame.width * 0.95,
                                 height: self.frame.height / 3)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.refreshControl = refreshControl
    }

    private func setupActivityIndicator() {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 96, height: 96)
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        addSubview(activityIndicator)
    }
}

extension RecruitmentCatalogView: StoryboardView {
    func bind(reactor: RecruitmentCatalogViewReactor) {
        Observable<Void>.just(())
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged)
            .map { [weak self] _ in Reactor.Action.reload(self?.searchController.searchBar.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.text
            .distinctUntilChanged()
            .skip(1)
            .map(Reactor.Action.search)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        searchController.searchBar.rx.cancelButtonClicked
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        collectionView.rx.isReachedBottom
            .map { [weak self] _ in self?.searchController.searchBar.text }
            .map(Reactor.Action.paginate)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

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

        reactor.state.map { $0.page }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] page in
                guard let self = self else {
                    return
                }
                var snapshot = DiffableDataSourceSnapshot<Section, CellItem>()
                snapshot.appendSections([.recruitmentCatalog])
                snapshot.appendItems(page.collection, toSection: .recruitmentCatalog)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension RecruitmentCatalogView: UISearchBarDelegate {
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
