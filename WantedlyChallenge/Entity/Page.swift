//
//  Page.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

struct Page<T> where T: Codable {
    let pageNumber: Int
    let collection: [T]
}
