//
//  RecruitmenrStore.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/21.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

protocol RecruitmentStoreType {
    func store(recruitments: [Recruitment])
    func load(id: Int) -> Recruitment?
    func clear()
}

final class RecruitmentStore: RecruitmentStoreType {
    private var storeDictionary: [String: [Recruitment]] = [:]

    func store(recruitments: [Recruitment]) {
        if let storedRecruitments = storeDictionary["Recruitment"] {
            storeDictionary["Recruitment"] = storedRecruitments + recruitments
        } else {
            storeDictionary["Recruitment"] = recruitments
        }
    }

    func load(id: Int) -> Recruitment? {
        guard let recruitments = storeDictionary["Recruitment"] else {
            return nil
        }
        return recruitments.first { recruitment -> Bool in
            recruitment.id == id
        }
    }

    func clear() {
        storeDictionary = [:]
    }
}
