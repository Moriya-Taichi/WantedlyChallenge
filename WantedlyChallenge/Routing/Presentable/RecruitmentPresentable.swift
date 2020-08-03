//
//  RecruitmentPresentable.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

enum TransitionEvent {
    case showRecruitment(Int)
    case showApplication(Int)
    case back
    case dismiss
}

protocol RecruitmentPresentable: RecruitmentCreatable {
    func showRecruitment(id: Int)
    func showApplication(id: Int)
    func back()
    func dismiss()
}

extension RecruitmentPresentable where Self: NavigationRouter {
    func showRecruitment(id: Int) {
        let recruitmentViewController = createRecruitment(id: id)
        recruitmentViewController.router = self
        navigationController.pushViewController(recruitmentViewController, animated: true)
    }

    func showApplication(id: Int) {
        let applicationViewController = createApplication(id: id)
        applicationViewController.modalPresentationStyle = .overFullScreen
        applicationViewController.modalTransitionStyle = .crossDissolve
        applicationViewController.router = self
        viewController.present(
            applicationViewController,
            animated: true
        )
    }

    func back() {
        navigationController.popViewController(animated: true)
    }

    func dismiss() {
        viewController.presentedViewController?.dismiss(animated: true)
    }
}
