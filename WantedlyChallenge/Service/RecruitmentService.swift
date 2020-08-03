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
    func fetchRecruitment(id: Int) -> Observable<Recruitment>
}

struct RecruitmentService: RecruitmentServiceType {
    private let repository: RecruitmentRepositoryType
    private let store: RecruitmentStoreType

    enum RecruitmentServiceError: Error {
        case fetchFailed
    }

    init(
        repository: RecruitmentRepositoryType,
        store: RecruitmentStoreType
    ) {
        self.repository = repository
        self.store = store
    }

    func fetchRecruitment(page: Int) -> Observable<Page<Recruitment>> {
        let input = WantedlyRequestType.nothing(page + 1)
        return repository.fetchRecruitment(input: input)
            .map { recruitments in
                Page(pageNumber: page + 1, collection: recruitments)
            }
            .do(onSuccess: { newPage in
                if page == 0 {
                    self.store.clear()
                    self.store.store(recruitments: newPage.collection)
                } else {
                    self.store.store(recruitments: newPage.collection)
                }
            })
            .asObservable()
    }

    func serchRecruitment(word: String, page: Int)
        -> Observable<Page<Recruitment>>
    {
        let input = WantedlyRequestType.search((word: word, page: page + 1))
        return repository.fetchRecruitment(input: input)
            .map { recruitments in
                Page(pageNumber: page + 1, collection: recruitments)
            }
            .do(onSuccess: { newPage in
                if page == 0 {
                    self.store.clear()
                    self.store.store(recruitments: newPage.collection)
                } else {
                    self.store.store(recruitments: newPage.collection)
                }
            })
            .asObservable()
    }

    func fetchRecruitment(id: Int) -> Observable<Recruitment> {
        return Observable.create { observer in
            if let recruitment = self.store.load(id: id) {
                observer.onNext(recruitment)
            } else {
                observer.onError(RecruitmentServiceError.fetchFailed)
            }
            return Disposables.create()
        }
    }
}
