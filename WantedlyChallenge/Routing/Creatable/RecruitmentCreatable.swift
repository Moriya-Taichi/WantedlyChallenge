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
    func createRecruitmentCatalog() -> RecrutingCatalogViewController
}

extension RecruitmentCreatable where Self: NavigationRouter {
    func createRecruitmentCatalog() -> RecrutingCatalogViewController {
        let recruitmentViewController = RecrutingCatalogViewController()
        recruitmentViewController.reactor = RecrutingCatalogViewReactor(recruitmentService: self.container~>)
        return recruitmentViewController
    }
}
