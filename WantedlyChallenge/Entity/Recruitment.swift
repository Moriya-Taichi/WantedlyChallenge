//
//  Recruitting.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

struct Recruitment: Codable {
    let id: Int
    let title: String
    let description: String
    let image: RecruitingImage
    let canSupport: Bool
    let canBookmark: Bool
    let lookingFor: String
    let publishedAt: String
    let candidateCount: Int
    let pageView: Int
    let location: String
    let locationSuffix: String
    let staffings: [RecruitingStaff]
    let leader: RecruitingLeader
    let company: RecruitingCompany
}

struct RecruitingImage: Codable {
    let original: String
}

struct RecruitingCompany: Codable {
    let id: Int
    let name: String
    let founder: String
    let foundedOn: String
    let addressPrefix: String
    let addressSuffix: String
    let latitude: Double
    let longnitude: Double
    let url: String
    let fontColorCode: String
    let avatar: RecruitingImage
}

struct RecruitingStaff: Codable {
    let userId: String
    let isLeader: Bool
    let name: String
    let description: String
    let facebookUid: String?
}

struct RecruitingLeader: Codable {
    let nameJa: String?
    let nameEn: String?
    let facebookUid: String?
}

