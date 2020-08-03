//
//  RwcruitmentCellViewReactor.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift

final class RecruitmentCellViewReactor: HashableReactor {
    private let recruitmentService: RecruitmentServiceType
    let identifier: Int
    var initialState: State

    enum Action {
        case bookmark
    }

    enum Mutation {
        case setIsBookmarked(Bool)
    }

    struct State {
        var isBookmark: Bool
        let recruitment: Recruitment
    }

    init(recruitment: Recruitment, recruitmentService: RecruitmentServiceType) {
        identifier = recruitment.id
        self.recruitmentService = recruitmentService
        initialState = State(
            isBookmark: recruitment.canBookmark,
            recruitment: recruitment
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .bookmark:
            // 本来ならここで通信処理
            return .just(.setIsBookmarked(!currentState.isBookmark))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setIsBookmarked(isBookmark):
            newState.isBookmark = isBookmark
        }
        return newState
    }
}
