//
//  Staff.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

struct Staff: Codable, Hashable {
    let userId: Int
    let isLeader: Bool
    let name: String
    let description: String?
    let facebookUid: String?
}
