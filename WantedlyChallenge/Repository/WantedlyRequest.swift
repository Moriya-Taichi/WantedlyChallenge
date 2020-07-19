//
//  WantedlyMoyaClient.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/19.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation
import Moya

enum WantedlyRequestType {
    case nothing(Int)
    case search((word: String, page: Int))
}

extension WantedlyRequestType: TargetType {
    var baseURL: URL {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String,
            let url = URL(string: urlString) else {
                fatalError("Loading Url failed")
        }
        return url
    }

    var path: String {
        switch self {
        case let .nothing(page):
            return "?page\(page)"
        case let .search(param):
            return "?q=\(param.word)&page=\(param.page)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        guard
            let mockPath = Bundle.main.path(forResource: "mock",
                                            ofType: "json"),
            let data = FileHandle(forReadingAtPath: mockPath)?.readDataToEndOfFile()
            else {
                return .init()
        }
        return data
    }

    var task: Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return nil
    }


}
