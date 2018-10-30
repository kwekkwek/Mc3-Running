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

struct Kelompok : Codable {
    let idGroup :String?
    let namaGroup :String?
    enum CodingKeys: String , CodingKey {
        case idGroup, namaGroup
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

struct RootClass:Codable {
    let id: String?
    let latitude: Float?
    let longitude: Float?
    
    enum CodingKeys: String,CodingKey {
        case id = "id"
        case longitude = "longitude"
        case latitude = "latitude"
    }
}
struct History: Codable {
    let pace, distance, calories, dateTime: String?
    enum CodingKeys: String, CodingKey {
        case pace = "pace"
        case distance = "distance"
        case calories = "calories"
        case dateTime = "dateTime"
    }
}

struct Histories: Codable {
    let histories:[History]?
    enum CodingKeys: String, CodingKey {
        case histories = "history"
    }
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        histories = try values.decodeIfPresent([History].self, forKey: .histories)
//    }
//    
}



extension String {
    
    static func random(length: Int = 4) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    static func random1(length: Int = 1) -> String {
        let base = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
}
