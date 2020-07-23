//
//  ApplicationView.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/23.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift
import UIKit

final class ApplicationView: UIView {

    @IBOutlet private weak var choicesTableView: UITableView!
    @IBOutlet private weak var applicateButton: UIButton! {
        didSet {
            applicateButton.layer.cornerRadius = applicateButton.frame.height / 2
        }
    }
    @IBOutlet private weak var backgroundButton: UIButton!

    private let transitionEventSubject = PublishSubject<TransitionEvent>()
    var transitionEventStream: Observable<TransitionEvent> {
        return transitionEventSubject
    }

    var disposeBag: DisposeBag = .init()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
}

extension ApplicationView: StoryboardView {
    func bind(reactor: ApplicationViewReactor) {
        backgroundButton.rx.tap
            .map { _ in TransitionEvent.dismiss }
            .bind(to: transitionEventSubject)
            .disposed(by: disposeBag)
    }
}
