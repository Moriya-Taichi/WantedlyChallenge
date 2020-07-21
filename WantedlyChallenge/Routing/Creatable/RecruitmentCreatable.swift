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
}

extension RecruitmentCreatable where Self: NavigationRouter {
    func createRecruitmentCatalog() -> RecruitmentCatalogViewController {
        let recruitmentViewController = RecruitmentCatalogViewController()
        recruitmentViewController.reactor = RecrutingCatalogViewReactor(recruitmentService: self.container~>)
        return recruitmentViewController
    }
}
