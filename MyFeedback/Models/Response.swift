//
//  Response.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 06/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    var all: [All]
}

// MARK: - All
struct All: Codable {
    var id, text: String
    var type: TypeEnum
    var user: UserData?
    var upvotes: Int
    var userUpvoted: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text, type, user, upvotes, userUpvoted
    }
}

enum TypeEnum: String, Codable {
    case cat = "cat"
}

// MARK: - User
struct UserData: Codable {
    var id: String
    var name: Name

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

// MARK: - Name
struct Name: Codable {
    var first, last: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
