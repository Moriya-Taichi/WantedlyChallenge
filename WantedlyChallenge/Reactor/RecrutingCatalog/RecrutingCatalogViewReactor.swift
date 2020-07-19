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
        case search(String)
        case paginate
    }

    enum Mutation {
        case setRecrutings([Recruiting])
        case setPageNumber(Int)
        case setIsLoading(Bool)
    }

    struct State {
        var isLoading: Bool
    }

    var initialState: State

    private var pageNumber = 0

    init() {
        initialState = State(isLoading: false)
    }
}
