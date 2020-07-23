//
//  ApplicationViewReactor.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/23.
//  Copyright © 2020 Mori. All rights reserved.
//

import ReactorKit
import RxSwift

final class ApplicationViewReactor: Reactor {

    enum Action {
        case selectChoice(Int)
        case applicate
    }

    enum Mutation {
        case setChoice(String)
        case setIsSucceed(Bool)
    }

    struct State {
        var isSucceed: Bool
        var choices: [String]
        var selectedChoice: String?
        var isSelected: Bool {
            return selectedChoice != nil
        }
    }

    var initialState: State
    private let recruitmentId: Int
    private let choices = ["今すぐ一緒に働きたい",
                           "まずは話を聞いてみたい",
                           "少しだけ興味があります"]

    init(id: Int) {
        initialState = State(isSucceed: false, choices: choices ,selectedChoice: nil)
        recruitmentId = id
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectChoice(index):
            guard index < currentState.choices.count else { return .empty() }
            return .just(.setChoice(currentState.choices[index]))
        case .applicate:
            //本来はここで通信
            return .just(.setIsSucceed(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setChoice(choice):
            newState.selectedChoice = choice
        case let .setIsSucceed(isSucceed):
            newState.isSucceed = isSucceed
        }
        return newState
    }
}
