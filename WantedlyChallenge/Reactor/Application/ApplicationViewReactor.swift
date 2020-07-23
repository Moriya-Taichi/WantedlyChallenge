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
    }

    enum Mutation {
        case setChoice(String)
    }

    struct State {
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
        initialState = State(choices: choices ,selectedChoice: nil)
        recruitmentId = id
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectChoice(index):
            guard index < currentState.choices.count else { return .empty() }
            return .just(.setChoice(currentState.choices[index]))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setChoice(choice):
            newState.selectedChoice = choice
        }
        return newState
    }
}
