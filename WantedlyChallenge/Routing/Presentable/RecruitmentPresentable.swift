//
//  RecruitmentPresentable.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

protocol RecruitmentPresentable: RecruitmentCreatable {
    func showRecruitment(id: Int)
}

extension RecruitmentPresentable where Self: NavigationRouter {
    func showRecruitment(id: Int) {
        let recruitmentViewController = createRecruitment(id: id)
        self.navigationController.pushViewController(recruitmentViewController, animated: true)
    }
}
