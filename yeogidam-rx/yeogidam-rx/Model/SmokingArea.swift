//
//  SmokingArea.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/13.
//

import Foundation

struct SmokingArea: Codable {
    var id: Int
    var name: String
    var description: String
    var type: AreaType
    var category: Category
    var location: Location
}

struct AreaType: Codable {
    var code: String
    var name: String
}

struct Category: Codable {
    var id: Int
    var name: String
}
