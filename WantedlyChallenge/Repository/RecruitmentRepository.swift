//
//  RecruitmentRepository.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation
import RxSwift
import RxMoya
import Moya

protocol RecruitmentRepositoryType {
    func fetchRecruitment(input: WantedlyRequestType)
        -> Single<[Recruitment]>
}

struct RecruitmentRepository: RecruitmentRepositoryType {

    let provider: MoyaProvider<WantedlyRequestType> = .init()

    func fetchRecruitment(input: WantedlyRequestType)
        -> Single<[Recruitment]> {
            provider.rx.request(input)
                .map([Recruitment].self)
    }
}


