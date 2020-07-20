//
//  Recruitment.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

struct Recruitment: Codable, Hashable {
    let id: Int
    let title: String
    let description: String
    let image: Image
    let canSupport: Bool
    let canBookmark: Bool
    let lookingFor: String
    let publishedAt: String
    let candidateCount: Int
    let pageView: Int
    let location: String
    let locationSuffix: String
    let staffings: [Staff]
    let leader: Leader
    let company: Company
}
