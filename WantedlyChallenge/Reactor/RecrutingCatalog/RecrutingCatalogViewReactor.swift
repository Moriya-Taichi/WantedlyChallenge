//
//  RecrutingCatalogViewReactor.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/18.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift

final class RecrutingCatalogViewReactor: Reactor {

    enum Action {
        case load
        case search(String?)
        case paginate(String?)
    }

    enum Mutation {
        case setRecruitments(Page<CellItem>)
        case setIsLoading(Bool)
    }

    struct State {
        var page: Page<CellItem>
        var isLoading: Bool
    }

    var initialState: State
    private let recruitmentService: RecruitmentServiceType

    init(recruitmentService: RecruitmentServiceType) {
        initialState = State(page: .init(pageNumber: 0,
                                         collection: []),
                             isLoading: false)
        self.recruitmentService = recruitmentService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        let startLoading: Observable<Mutation> = .just(.setIsLoading(true))
        let endLoading: Observable<Mutation> = .just(.setIsLoading(false))
        switch action {
        case .load:
            let rectuitment = recruitmentService
                .fetchRecruitment(page: 0)
                .map { $0.map(CellItem.recruitmentCellItem) }
                .map(Mutation.setRecruitments)
            return .concat([startLoading, rectuitment, endLoading])
        case let .search(word):
            guard let word = word, !word.isEmpty else {
                self.action.onNext(.load)
                return .empty()
            }
            let serchedRecruitments = recruitmentService
                .serchRecruitment(word: word,
                                  page: 0)
                .map { $0.map(CellItem.recruitmentCellItem) }
                .map(Mutation.setRecruitments)
            return .concat([startLoading, serchedRecruitments, endLoading])
        case let .paginate(word):
            guard let word = word, !word.isEmpty else {
                let recruitmentPagination = recruitmentService
                    .fetchRecruitment(page: currentState.page.pageNumber)
                    .map { $0.map(CellItem.recruitmentCellItem) }
                    .map { self.currentState.page.paginate($0) }
                    .map(Mutation.setRecruitments)
                return .concat([startLoading, recruitmentPagination, endLoading])
            }
            let serchPagenation = recruitmentService
                .serchRecruitment(word: word,
                                  page: currentState.page.pageNumber)
                .map { $0.map(CellItem.recruitmentCellItem) }
                .map { self.currentState.page.paginate($0) }
                .map(Mutation.setRecruitments)
            return .concat([startLoading, serchPagenation, endLoading])
        }
    }
}
