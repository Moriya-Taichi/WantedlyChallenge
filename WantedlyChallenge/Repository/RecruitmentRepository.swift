//
//  RecruitmentRepository.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

protocol RecruitmentRepositoryType {
    func fetchRecruitment(input: WantedlyRequestType)
        -> Single<[Recruitment]>
}

struct RecruitmentRepository: RecruitmentRepositoryType {
    let provider: MoyaProvider<WantedlyRequestType> = .init()

    func fetchRecruitment(input: WantedlyRequestType)
        -> Single<[Recruitment]>
    {
        return provider.rx.request(input)
            .map { response -> [Recruitment] in
                do {
                    let jsonObject = try JSONSerialization.jsonObject(
                        with: response.data,
                        options: .fragmentsAllowed
                    ) as? [String: Any]
                    let recruitment = try parse([Recruitment].self, data: jsonObject?["data"])
                    return recruitment
                } catch {
                    throw error
                }
            }
    }
}
