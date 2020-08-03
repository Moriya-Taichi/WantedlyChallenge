//
//  RecrutingCellView.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/18.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxOptional
import RxSwift
import SDWebImage
import UIKit

final class RecruitmentCellView: UIView {
    @IBOutlet private var recruitImageView: UIImageView!
    @IBOutlet var bookmarkButton: UIButton!

    @IBOutlet private var lookingForLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!

    @IBOutlet private var companyIconView: UIImageView! {
        didSet {
            companyIconView.layer.cornerRadius = companyIconView.frame.width / 2
        }
    }

    @IBOutlet private var companyNameLabel: UILabel!

    var disposeBag = DisposeBag()
    let mediumFeedBackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let lightFeedbackgGenerator = UIImpactFeedbackGenerator(style: .light)

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }

    private func setContents(recruitment: Recruitment) {
        titleLabel.text = recruitment.title
        lookingForLabel.text = recruitment.lookingFor
        companyNameLabel.text = recruitment.company.name

        companyIconView.sd_setImage(with: URL(string: recruitment.company.avatar.s50))
        recruitImageView.sd_setImage(with: URL(string: recruitment.image.i320131X2))
        bookmarkButton.isSelected = recruitment.canBookmark
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

extension RecruitmentCellView: StoryboardView {
    func bind(reactor: RecruitmentCellViewReactor) {
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
                    self.bookmarkButton.tintColor = .white
                }
            })
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
    }
}
