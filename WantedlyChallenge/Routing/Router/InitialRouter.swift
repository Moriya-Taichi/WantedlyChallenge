//
//  InitialRouter.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import Swinject
import UIKit

protocol Router {
    var container: Resolver { get }
    var viewController: UIViewController { get }
    func navigate()
}

protocol NavigationRouter: Router {
    var navigationController: UINavigationController { get }
}

extension NavigationRouter {
    var viewController: UIViewController {
        return navigationController
    }
}

final class InitialRouter: Router {

    var viewController: UIViewController
    var container: Resolver

    init(container: Resolver) {
        self.container = container
        self.viewController = .init()
    }

    func navigate() {
        let recruitRouter = RecrutingRouter(container: container,
                                            navigationController: .init())
        self.viewController = recruitRouter.viewController
        recruitRouter.navigate()
    }
}
