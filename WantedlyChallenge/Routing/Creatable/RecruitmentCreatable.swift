//
//  RecruitingCreatable.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import SwinjectAutoregistration
import Swinject

protocol RecruitmentCreatable {
    func createRecruitmentCatalog() -> RecruitmentCatalogViewController
    func createRecruitment(id: Int) -> RecruitmentViewController
}

extension RecruitmentCreatable where Self: NavigationRouter {
    func createRecruitmentCatalog() -> RecruitmentCatalogViewController {
        let recruitmentViewController = RecruitmentCatalogViewController()
        recruitmentViewController.reactor = RecruitmentCatalogViewReactor(recruitmentService: self.container~>)
        return recruitmentViewController
    }

    func createRecruitment(id: Int) -> RecruitmentViewController {
        let recruitmentViewController = RecruitmentViewController()
        recruitmentViewController.reactor = RecruitmentViewReactor(id: id,
                                                                   recruitmentService: self.container~>)
        return recruitmentViewController
    }
}
