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
    var scale: Scale
    var management: Management
    var establishedAt: String
    var establishedBy: String
    var updatedAt: String
}

struct AreaType: Codable {
    var code: String
    var name: String
}

struct Category: Codable {
    var id: Int
    var name: String
}

struct Scale: Codable {
    var value: Int
    var unit: String
    var displayString: String
}

struct Management: Codable {
    var isUnderManagement: Bool
    var managerName: String?
}
