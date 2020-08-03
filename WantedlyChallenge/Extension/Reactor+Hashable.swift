//
//  Reactor+Hashable.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/08/04.
//

import ReactorKit

protocol HashableReactor: Reactor, Hashable {
    associatedtype IdentifierType: Hashable
    var identifier: IdentifierType { get }
}

extension HashableReactor {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
