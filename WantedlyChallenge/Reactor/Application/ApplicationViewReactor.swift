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

    }

    enum Mutation {

    }

    struct State {

    }

    var initialState: State
    private let recruitmentId: Int

    init(id: Int) {
        initialState = State()
        recruitmentId = id
    }
}
