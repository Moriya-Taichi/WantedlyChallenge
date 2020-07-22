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
        case bookmark
        case selectStaff(Int)
    }

    enum Mutation {
        case setRecruitment(Recruitment)
        case setIsBookmark(Bool)
        case setStaff(Staff)
    }

    struct State {
        var recruitment: Recruitment?
        var isBookmark: Bool
        var displayStaff: Staff?
    }

    var initialState: State
    private let recruitmentId: Int
    private let recruitmentService: RecruitmentServiceType

    init(id: Int, recruitmentService: RecruitmentServiceType) {
        initialState = State(recruitment: nil, isBookmark: false, displayStaff: nil)
        self.recruitmentId = id
        self.recruitmentService = recruitmentService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            let recruitment = recruitmentService.fetchRecruitment(id: recruitmentId)
                .flatMap { recruitment -> Observable<Mutation> in
                    if let staff = recruitment.staffings.first {
                        return .concat([.just(.setRecruitment(recruitment)),
                                        .just(.setIsBookmark(recruitment.canBookmark)),
                                        .just(.setStaff(staff))])
                    }
                    return .concat([.just(.setRecruitment(recruitment)),
                                    .just(.setIsBookmark(recruitment.canBookmark))])
            }
            return recruitment
        case .bookmark:
            return .just(.setIsBookmark(!currentState.isBookmark))
        case let .selectStaff(index):
            guard
                let recruitment = currentState.recruitment,
                index < recruitment.staffings.count
                else { return .empty() }
            return .just(.setStaff(recruitment.staffings[index]))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRecruitment(recruitment):
            newState.recruitment = recruitment
        case let .setIsBookmark(isBookamerk):
            newState.isBookmark = isBookamerk
        case let .setStaff(staff):
            newState.displayStaff = staff
        }
        return newState
    }
}
