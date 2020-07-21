//
//  RecruitmentViewReactor.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift

final class RecruitmentViewReactor: Reactor {

    enum Action {
        case load
    }

    enum Mutation {
        case setRecruitment(Recruitment)
    }

    struct State {
        var recruitment: Recruitment?
    }

    var initialState: State
    private let recruitmentId: Int
    private let recruitmentService: RecruitmentServiceType

    init(recruitmentId: Int, recruitmentService: RecruitmentServiceType) {
        initialState = State(recruitment: nil)
        self.recruitmentId = recruitmentId
        self.recruitmentService = recruitmentService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return recruitmentService.fetchRecruitment(id: recruitmentId)
                .map(Mutation.setRecruitment)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRecruitment(recruitment):
            newState.recruitment = recruitment
        }
        return newState
    }
}
