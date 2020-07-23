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

    @IBOutlet private weak var completedLabel: UILabel! {
        didSet {
            completedLabel.text = "応募が完了しました！\n企業からの連絡を待ちましょう！"
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var choicesTableView: UITableView! {
        didSet {
            choicesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        }
    }
    @IBOutlet private weak var applicateButton: UIButton! {
        didSet {
            applicateButton.layer.cornerRadius = applicateButton.frame.height / 2
            applicateButton.setTitleColor(.white, for: .normal)
            applicateButton.setTitleColor(.lightGray, for: .disabled)
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
        choicesTableView.rx.itemSelected
            .do(onNext: {[weak self] indexPath in
                guard
                    let self = self,
                    let cell = self.choicesTableView.cellForRow(at: indexPath)
                    else {
                        return
                }
                cell.accessoryType = .checkmark
            })
            .map { Reactor.Action.selectChoice($0.row) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        choicesTableView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                guard
                    let self = self,
                    let cell = self.choicesTableView.cellForRow(at: indexPath)
                    else {
                        return
                }
                cell.accessoryType = .none
            })
            .disposed(by: disposeBag)

        backgroundButton.rx.tap
            .map { _ in TransitionEvent.dismiss }
            .bind(to: transitionEventSubject)
            .disposed(by: disposeBag)

        applicateButton.rx.tap
            .map { _ in Reactor.Action.applicate }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.map { $0.isSucceed }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.3,
                               animations: {
                                self?.applicateButton.alpha = 0
                                self?.choicesTableView.alpha = 0
                                self?.titleLabel.alpha = 0
                }) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.transitionEventSubject.onNext(.dismiss)
                    }
                }
            })
            .disposed(by: disposeBag)

        reactor.state.map { $0.choices }
            .distinctUntilChanged()
            .bind(to: choicesTableView.rx.items(cellIdentifier: "Cell")) { row, item, cell in
                cell.textLabel?.text = item
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)

        reactor.state.map { $0.isSelected }
            .distinctUntilChanged()
            .bind(to: applicateButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
