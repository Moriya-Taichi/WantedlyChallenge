//
//  Container.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import SwinjectAutoregistration
import Swinject

final class DIContainer: Assembly {
    func assemble(container: Container) {
        container
            .autoregister(RecruitmentRepositoryType.self,
                          initializer: RecruitmentRepository.init)
            .inObjectScope(.container)

        container
            .autoregister(RecruitmentServiceType.self,
                          initializer: RecruitmentService.init)
            .inObjectScope(.container)

        container
            .autoregister(RecruitmentStoreType.self,
                          initializer: RecruitmentStore.init)
            .inObjectScope(.container)
    }
}
