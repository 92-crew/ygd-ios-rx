//
//  Location.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/13.
//

import Foundation

struct Location: Codable {
    var si: Si
    var gu: Gu
    var road: String
    var roadCode: Int
    var building: String
    var detail: String
    var latitude: Double
    var longitude: Double
}

struct Si: Codable {
    var code: Int
    var name: String
}

struct Gu: Codable {
    var code: Int
    var name: String
}
