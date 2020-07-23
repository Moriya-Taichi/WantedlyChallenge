//
//  ApplicationViewController.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/23.
//  Copyright © 2020 Mori. All rights reserved.
//

import RxSwift
import UIKit

final class ApplicationViewController: UIViewController {
    private var applicationView: ApplicationView?
    var reactor: ApplicationViewReactor?
    var router: RecruitmentPresentable?

    private let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applicationView = ApplicationView(frame: self.view.frame)
        guard let applicationView = applicationView else {
            return
        }
        applicationView.reactor = reactor
        self.view.addSubview(applicationView)

        applicationView.transitionEventStream
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .dismiss:
                    self?.router?.dismiss()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
