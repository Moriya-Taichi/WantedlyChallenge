//
//  RecruitmentView.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift
import UIKit

final class RecruitmentView: UIView {
    
    @IBOutlet private weak var safeAreaView: UIView!
    @IBOutlet private weak var navigationView: UIView!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var backButton: UIButton! {
        didSet {
            backButton.layer.cornerRadius = backButton.frame.width / 2
        }
    }
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var applicationButoton: UIButton! {
        didSet {
            applicationButoton.layer.cornerRadius = applicationButoton.frame.height / 2
        }
    }
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet private weak var lookingForLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var companyIconImageView: UIImageView! {
        didSet {
            companyIconImageView.layer.cornerRadius = companyIconImageView.frame.width / 2
        }
    }
    @IBOutlet private weak var companyNameLabel: UILabel!

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var workDeacriptionLabel: UILabel!
    @IBOutlet private weak var missionLabel: UILabel!
    @IBOutlet private weak var approachLabel: UILabel!

    @IBOutlet private weak var staffCollectionView: UICollectionView!
    @IBOutlet private weak var staffNameLabel: UILabel!
    @IBOutlet private weak var staffDescriptionLabel: UILabel!

    private var defaultHeaderHeight: CGFloat {
        return self.frame.height * 0.32
    }

    var disposeBag = DisposeBag()

    private let transactionEventSubject = PublishSubject<Void>()
    var transactionEventStream: Observable<Void> {
        return transactionEventSubject
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
        navigationView.alpha = 0.0
        safeAreaView.alpha = 0.0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
        navigationView.alpha = 0.0
        safeAreaView.alpha = 0.0
    }

    private func setContents(recruitment: Recruitment?) {
        guard let recruitment = recruitment else { return }
        headerImageView.sd_setImage(with: URL(string: recruitment.image.original))
        companyIconImageView.sd_setImage(with: URL(string: recruitment.company.avatar.original))
        companyNameLabel.text = recruitment.company.name
        titleLabel.text = recruitment.title
        lookingForLabel.text = recruitment.lookingFor
        descriptionLabel.text = recruitment.description

    }
}

extension RecruitmentView: StoryboardView {
    func bind(reactor: RecruitmentViewReactor) {
        Observable<Void>.just(())
            .map { _ in Reactor.Action.load }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        backButton.rx.tap
            .bind(to: transactionEventSubject)
            .disposed(by: disposeBag)

        reactor.state.map { $0.recruitment }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] recruitment in
                self?.setContents(recruitment: recruitment)
            })
            .disposed(by: disposeBag)

        scrollView.rx.contentOffset
            .subscribe(onNext: {[weak self] contentOffset in
                self?.handleScroll(scroll: contentOffset.y)
            })
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
            headerContainerViewExpandY(-(scroll) + defaultHeaderHeight)
            adjustHeaderContainerTopOffset(by: 0)
        case getScrollPointToStickNavigationBar()...:
            headerContainerViewExpandY(defaultHeaderHeight)
            adjustHeaderContainerTopOffset(by: -(getScrollPointToStickNavigationBar()))
        case 0...:
            headerContainerViewExpandY(defaultHeaderHeight)
            adjustHeaderContainerTopOffset(by: -(scroll))
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
        return  defaultHeaderHeight - (UIApplication.shared.statusBarFrame.height + 44)

    }
}
