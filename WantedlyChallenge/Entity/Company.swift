//
//  Company.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

struct Company: Codable, Hashable {
    let id: Int
    let name: String
    let founder: String?
    let foundedOn: String?
    let addressPrefix: String
    let addressSuffix: String
    let latitude: Double?
    let longitude: Double?
    let url: String
    let fontColorCode: String
    let avatar: Image
}
