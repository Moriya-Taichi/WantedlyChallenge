//
//  RecrutingCellView.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/18.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import SDWebImage
import RxOptional
import RxSwift
import UIKit

final class RecruitmentCellView: UIView {

    @IBOutlet private weak var recruitImageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!

    @IBOutlet private weak var lookingForLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var companyIconView: UIImageView! {
        didSet {
            companyIconView.layer.cornerRadius = companyIconView.frame.width / 2
        }
    }
    @IBOutlet private weak var companyNameLabel: UILabel!

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

    func setContents(recruitment: Recruitment) {

        titleLabel.text = recruitment.title
        lookingForLabel.text = recruitment.lookingFor
        companyNameLabel.text = recruitment.company.name

        companyIconView.sd_setImage(with: URL(string: recruitment.company.avatar.original))
        recruitImageView.sd_setImage(with: URL(string: recruitment.image.original))
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
            .bind(to: bookmarkButton.rx.isSelected)
            .disposed(by: disposeBag)

        bookmarkButton.rx.tap
            .do(onNext: {[weak self] _ in
                guard let self = self else {
                    return
                }
                if self.bookmarkButton.isSelected {
                    self.lightFeedbackgGenerator.prepare()
                    self.lightFeedbackgGenerator.impactOccurred()
                } else {
                    self.mediumFeedBackGenerator.prepare()
                    self.mediumFeedBackGenerator.impactOccurred()
                }
            })
            .map{ _ in Reactor.Action.bookmark }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
