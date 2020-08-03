//
//  RecrutingCatalogViewReactor.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/18.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

final class RecruitmentCatalogViewReactor: Reactor {
    enum Action {
        case load
        case reload(String?)
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
        initialState = State(
            page: .init(
                pageNumber: 0,
                collection: []
            ),
            isLoading: false
        )
        self.recruitmentService = recruitmentService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        let startLoading: Observable<Mutation> = .just(.setIsLoading(true))
        let endLoading: Observable<Mutation> = .just(.setIsLoading(false))
        switch action {
        case .load:
            guard !currentState.isLoading else { return .empty() }
            let rectuitment = recruitmentService
                .fetchRecruitment(page: 0)
                .map { $0.map(CellItem.recruitmentCellItem) }
                .map(Mutation.setRecruitments)
            return .concat([startLoading, rectuitment, endLoading])
        case let .reload(word):
            if let word = word, word.isEmpty {
                self.action.onNext(.load)
            } else {
                self.action.onNext(.search(word))
            }
            return .empty()
        case let .search(word):
            guard let word = word else {
                return .empty()
            }

            if word.isEmpty {
                self.action.onNext(.load)
                return .empty()
            }
            let serchedRecruitments = recruitmentService
                .serchRecruitment(
                    word: word,
                    page: 0
            )
                .map { $0.map(CellItem.recruitmentCellItem) }
                .map(Mutation.setRecruitments)
                .takeUntil(self.action.filter {
                    if case .search = $0 {
                        return true
                    } else {
                        return false
                    }
                })
            return .concat([startLoading, serchedRecruitments, endLoading])
        case let .paginate(word):
            guard
                !currentState.isLoading,
                !currentState.page.collection.isEmpty
                else {
                    return .empty()
            }
            guard let word = word, !word.isEmpty else {
                let recruitmentPagination = recruitmentService
                    .fetchRecruitment(page: currentState.page.pageNumber)
                    .map { $0.map(CellItem.recruitmentCellItem) }
                    .map { self.currentState.page.paginate($0) }
                    .map(Mutation.setRecruitments)
                return .concat([startLoading, recruitmentPagination, endLoading])
            }
            let serchPagenation = recruitmentService
                .serchRecruitment(
                    word: word,
                    page: currentState.page.pageNumber
            )
                .map { $0.map(CellItem.recruitmentCellItem) }
                .map { self.currentState.page.paginate($0) }
                .map(Mutation.setRecruitments)
            return .concat([startLoading, serchPagenation, endLoading])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        case let .setRecruitments(recruitments):
            newState.page = recruitments
        }
        return newState
    }
}
