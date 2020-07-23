//
//  RecruitmentViewController.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift
import UIKit

final class RecruitmentViewController: UIViewController {

    private var recruitmentView: RecruitmentView?
    var reactor: RecruitmentViewReactor?
    var router: RecruitmentPresentable?
    let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        recruitmentView = RecruitmentView(frame: self.view.bounds)
        guard let recruitmentView = recruitmentView else {
            return
        }
        recruitmentView.reactor = reactor
        self.view.addSubview(recruitmentView)
        recruitmentView.transitionEventStream
            .subscribe(onNext: {[weak self] event in
                switch event {
                case .back:
                    self?.router?.back()
                case let .showApplication(id):
                    self?.router?.showApplication(id: id)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
