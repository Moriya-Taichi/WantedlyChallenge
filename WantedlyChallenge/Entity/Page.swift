//
//  Page.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

struct Page<T: Hashable>: Equatable {

    let pageNumber: Int
    let collection: [T]

    static func == (lhs: Page<T>, rhs: Page<T>) -> Bool {
        return lhs.collection.hashValue == rhs.collection.hashValue
    }

    func map<Output>(_ transform: (T) -> Output) -> Page<Output> {
        let mappedCollection = self.collection.map(transform)
        return Page<Output>(pageNumber: self.pageNumber,
                            collection: mappedCollection)
    }

    func paginate(_ page: Self) -> Self {
        return Page(pageNumber: page.pageNumber,
                    collection: self.collection + page.collection)
    }
}
