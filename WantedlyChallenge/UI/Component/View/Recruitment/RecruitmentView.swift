//
//  RecruitmentView.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import DiffableDataSources
import ReactorKit
import RxSwift
import UIKit

final class RecruitmentView: UIView {
    @IBOutlet private var safeAreaView: UIView!
    @IBOutlet private var navigationView: UIView!
    @IBOutlet private var headerView: UIView!
    @IBOutlet private var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var scrollView: UIScrollView! {
        didSet {
            scrollView.contentInset = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: scrollView.frame.height / 3,
                right: 0
            )
        }
    }

    @IBOutlet private var backButton: UIButton! {
        didSet {
            backButton.layer.cornerRadius = backButton.frame.width / 2
        }
    }

    @IBOutlet private var bookmarkButton: UIButton!
    @IBOutlet private var applicationButoton: UIButton! {
        didSet {
            applicationButoton.layer.cornerRadius = applicationButoton.frame.height / 2
        }
    }

    @IBOutlet private var headerImageView: UIImageView!
    @IBOutlet private var lookingForLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var companyIconImageView: UIImageView! {
        didSet {
            companyIconImageView.layer.cornerRadius = companyIconImageView.frame.width / 2
        }
    }

    @IBOutlet private var companyNameLabel: UILabel!

    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var workDeacriptionLabel: UILabel!
    @IBOutlet private var missionLabel: UILabel!
    @IBOutlet private var approachLabel: UILabel!

    @IBOutlet private var staffCollectionView: UICollectionView! {
        didSet {
            staffCollectionView.register(
                RecruitmentStaffCollectionViewCell.self,
                forCellWithReuseIdentifier: "RecruitmentStaffCollectionViewCell"
            )
        }
    }

    @IBOutlet private var staffNameLabel: UILabel!
    @IBOutlet private var staffDescriptionLabel: UILabel!

    private var defaultHeaderHeight: CGFloat {
        return frame.height * 0.32
    }

    var disposeBag = DisposeBag()

    private let transitionEventSubject = PublishSubject<TransitionEvent>()
    var transitionEventStream: Observable<TransitionEvent> {
        return transitionEventSubject
    }

    private let mediumFeedBackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let lightFeedbackgGenerator = UIImpactFeedbackGenerator(style: .light)
    private lazy var dataSource = CollectionViewDiffableDataSource<Section, CellItem>(
        collectionView: staffCollectionView
    ) { collectionView, indexPath, item -> UICollectionViewCell? in
        switch item {
        case let .staffCellItem(staff):
            guard
                let cell = collectionView.dequeReusableCell(
                    RecruitmentStaffCollectionViewCell.self,
                    indexPath: indexPath
                )
                else {
                    return UICollectionViewCell()
            }
            cell.setCellContents(staff: staff)
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
        setupStaffCollectionView()
        navigationView.alpha = 0.0
        safeAreaView.alpha = 0.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        setupStaffCollectionView()
        navigationView.alpha = 0.0
        safeAreaView.alpha = 0.0
    }

    private func setupStaffCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 0)
        layout.itemSize = CGSize(
            width: staffCollectionView.frame.height,
            height: staffCollectionView.frame.height
        )
        staffCollectionView.setCollectionViewLayout(layout, animated: true)
    }

    private func setContents(recruitment: Recruitment?) {
        guard let recruitment = recruitment else { return }
        headerImageView.sd_setImage(with: URL(string: recruitment.image.original))
        companyIconImageView.sd_setImage(with: URL(string: recruitment.company.avatar.original))
        companyNameLabel.text = recruitment.company.name
        titleLabel.text = recruitment.title
        lookingForLabel.text = recruitment.lookingFor
        descriptionLabel.text = recruitment.description
        var snapshot = DiffableDataSourceSnapshot<Section, CellItem>()
        snapshot.appendSections([.recruitmentStaff])
        snapshot.appendItems(
            recruitment.staffings.map(CellItem.staffCellItem),
            toSection: .recruitmentStaff
        )
        dataSource.apply(snapshot)
    }
}

extension RecruitmentView: StoryboardView {
    func bind(reactor: RecruitmentViewReactor) {
        Observable<Void>.just(())
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .map { _ in TransitionEvent.back }
            .bind(to: transitionEventSubject)
            .disposed(by: disposeBag)

        reactor.state.map { $0.recruitment }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] recruitment in
                self?.setContents(recruitment: recruitment)
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.isBookmark }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isBookmark in
                guard let self = self else {
                    return
                }
                self.bookmarkButton.isSelected = isBookmark
                if isBookmark {
                    self.bookmarkButton.tintColor = UIColor(
                        red: 17 / 255,
                        green: 146 / 255,
                        blue: 196 / 255,
                        alpha: 1
                    )
                } else {
                    self.bookmarkButton.tintColor = .lightGray
                }
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.displayStaff }
            .distinctUntilChanged()
            .filterNil()
            .subscribe(onNext: { [weak self] staff in
                self?.staffNameLabel.text = staff.name
                self?.staffDescriptionLabel.text = staff.description
            })
            .disposed(by: disposeBag)

        staffCollectionView.rx.itemSelected
            .map { Reactor.Action.selectStaff($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        bookmarkButton.rx.tap
            .do(onNext: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.animateBookmark(isBookmark: self.bookmarkButton.isSelected)
                if self.bookmarkButton.isSelected {
                    self.lightFeedbackgGenerator.prepare()
                    self.lightFeedbackgGenerator.impactOccurred()
                } else {
                    self.mediumFeedBackGenerator.prepare()
                    self.mediumFeedBackGenerator.impactOccurred()
                }
            })
            .map { _ in Reactor.Action.bookmark }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        scrollView.rx.contentOffset
            .subscribe(onNext: { [weak self] contentOffset in
                self?.handleScroll(scroll: contentOffset.y)
            })
            .disposed(by: disposeBag)

        applicationButoton.rx.tap
            .compactMap { _ in reactor.currentState.recruitment?.id }
            .map(TransitionEvent.showApplication)
            .bind(to: transitionEventSubject)
            .disposed(by: disposeBag)
    }
}

extension RecruitmentView {
    private func handleScroll(scroll: CGFloat) {
        let scroll = scroll + scrollView.contentInset.top
        switch scroll {
        case 0:
            headerContainerViewExpandY(defaultHeaderHeight)
            adjustHeaderContainerTopOffset(by: 0)
            navigationView.alpha = 0
            safeAreaView.alpha = 0
        case ...0:
            headerContainerViewExpandY(-scroll + defaultHeaderHeight)
            adjustHeaderContainerTopOffset(by: 0)
        case getScrollPointToStickNavigationBar()...:
            headerContainerViewExpandY(defaultHeaderHeight)
            adjustHeaderContainerTopOffset(by: -getScrollPointToStickNavigationBar())
        case 0...:
            headerContainerViewExpandY(defaultHeaderHeight)
            adjustHeaderContainerTopOffset(by: -scroll)
            let alpha = scroll / defaultHeaderHeight * 1.7
            navigationView.alpha = alpha > 1 ? 1 : alpha
            safeAreaView.alpha = alpha > 1 ? 1 : alpha
        default:
            headerHeightConstraint.constant = defaultHeaderHeight
        }
    }

    private func adjustHeaderContainerTopOffset(by offsetY: CGFloat) {
        headerView.transform = CGAffineTransform(translationX: headerView.transform.tx, y: offsetY)
    }

    private func headerContainerViewExpandY(_ value: CGFloat) {
        headerHeightConstraint.constant = value
    }

    private func getScrollPointToStickNavigationBar() -> CGFloat {
        return defaultHeaderHeight - (UIApplication.shared.statusBarFrame.height + 44)
    }

    private func animateBookmark(isBookmark: Bool) {
        if isBookmark {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.bookmarkButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
            ) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.bookmarkButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        } else {
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.bookmarkButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
            ) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.bookmarkButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        }
    }
}
