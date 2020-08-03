//
//  RecruitingCreatable.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

protocol RecruitmentCreatable {
    func createRecruitmentCatalog() -> RecruitmentCatalogViewController
    func createRecruitment(id: Int) -> RecruitmentViewController
    func createApplication(id: Int) -> ApplicationViewController
}

extension RecruitmentCreatable where Self: NavigationRouter {
    func createRecruitmentCatalog() -> RecruitmentCatalogViewController {
        let recruitmentViewController = RecruitmentCatalogViewController()
        recruitmentViewController.reactor = RecruitmentCatalogViewReactor(recruitmentService: container~>)
        return recruitmentViewController
    }

    func createApplication(id: Int) -> ApplicationViewController {
        let applicationViewController = ApplicationViewController()
        applicationViewController.reactor = ApplicationViewReactor(id: id)
        return applicationViewController
    }

    func createRecruitment(id: Int) -> RecruitmentViewController {
        let recruitmentViewController = RecruitmentViewController()
        recruitmentViewController.reactor = RecruitmentViewReactor(
            id: id,
            recruitmentService: container~>
        )
        return recruitmentViewController
    }
}
