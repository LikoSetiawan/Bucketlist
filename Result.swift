//
//  Result.swift
//  BucketList
//
//  Created by Liko Setiawan on 17/04/24.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable{
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    var description: String {
        terms?["description"]?.first ?? "No Further Information"
    }
    
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
