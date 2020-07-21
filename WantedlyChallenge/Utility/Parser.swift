//
//  Parser.swift
//  WantedlyChallenge
//
//  Created by Mori on 2020/07/20.
//  Copyright © 2020 Mori. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case parseError
}

func parse<E: Decodable>(_ type: E.Type, data: Any?) throws -> E {
    let json = try JSONSerialization.data(withJSONObject: data as Any)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(type, from: json)
}
