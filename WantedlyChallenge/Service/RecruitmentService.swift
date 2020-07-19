//
//  RecruitmentService.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation
import RxSwift

protocol RecruitmentServiceType {
    func fetchRecruitment(page: Int) -> Observable<Page<Recruitment>>
    func serchRecruitment(word: String, page: Int) -> Observable<Page<Recruitment>>
}

struct RecruitmentService: RecruitmentServiceType {

    let repository: RecruitmentRepositoryType

    init(repository: RecruitmentRepositoryType) {
        self.repository = repository
    }

    func fetchRecruitment(page: Int) -> Observable<Page<Recruitment>> {
        let input = WantedlyRequestType.nothing(page)
        return repository.fetchRecruitment(input: input)
            .map { recruitments in
                return Page(pageNumber: page + 1, collection: recruitments)
            }
            .asObservable()
    }

    func serchRecruitment(word: String, page: Int)
        -> Observable<Page<Recruitment>> {
            let input = WantedlyRequestType.search((word: word, page: page))
            return repository.fetchRecruitment(input: input)
                .map { recruitments in
                    return Page(pageNumber: page + 1, collection: recruitments)
                }
                .asObservable()
    }
}
