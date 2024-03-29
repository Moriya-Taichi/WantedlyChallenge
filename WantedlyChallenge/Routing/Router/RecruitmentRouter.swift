//
//  RecruitmentRouter.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import Swinject
import SwinjectAutoregistration
import UIKit

final class RecruitmentRouter: NavigationRouter, RecruitmentPresentable {
    var navigationController: UINavigationController
    var container: Resolver

    init(container: Resolver, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    func navigate() {
        let recruitmentViewController = createRecruitmentCatalog()
        recruitmentViewController.router = self
        navigationController.viewControllers = [recruitmentViewController]
    }
}
