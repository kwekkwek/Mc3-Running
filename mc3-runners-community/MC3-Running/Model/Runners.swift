//
//  Runners.swift
//  MC3-Running
//
//  Created by Benny Kurniawan on 12/10/18.
//  Copyright © 2018 Benny Kurniawan. All rights reserved.
//

import Foundation

struct Runners : Codable{
    let runs: [Run]?
    enum CodingKeys: String, CodingKey{
        case runs = "Runs"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        runs = try values.decodeIfPresent([Run].self, forKey: .runs)
    }
    
}
struct Run : Codable {
    let idRun: String?
    let distance: Double?
    let timeStart: Date?
    let timeStop: Date?
    let group: Group?
    let route: Route?
    let member: [Member]?
    enum CodingKeys: String , CodingKey {
        case idRun, distance, timeStart, timeStop
        case route = "Route"
        case group = "Group"
        case member = "Member"
    }
}
struct Group : Codable {
    let idGroup :String?
    let namaGroup :String?
    let createBy :String?
    let createTime :Date?
    enum CodingKeys: String , CodingKey {
        case idGroup, namaGroup, createBy
        case createTime = "time"
    }
}
struct Member: Codable {
    let idMember : String?
    let username : String?
    let position : Double?
    let joinTime : Date?
    enum CodingKeys: String , CodingKey {
        case idMember,username
        case position = "position"
        case joinTime = "joinTime"
    }
}
struct Route: Codable {
    let idRoute, start, finish: String?
    let checkPoint: [checkPoint]
    enum CodingKeys: String, CodingKey {
        case idRoute, start, finish
        case checkPoint = "CheckPoint"
    }
    
}
struct checkPoint: Codable {
    let longitude, latitude: String?
    enum CodingKeys: String, CodingKey {
        case longitude = "Longitude"
        case latitude = "Latitude"
    }
}
