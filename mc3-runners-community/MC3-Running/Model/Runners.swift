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

struct Members : Codable {
    
    let isAdmin : String?
    let namaMember : String?
    let latitude : Float?
    let longitude : Float?
    
    
    enum CodingKeys: String, CodingKey {
        case isAdmin = "isAdmin"
        case location = "location"
        case namaMember = "namaMember"
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isAdmin = try container.decode(String.self, forKey: .isAdmin)
        namaMember = try container.decode(String.self, forKey: .namaMember)
        let location = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        
        latitude = try location.decode(Float.self, forKey: .latitude)
        longitude = try location.decode(Float.self, forKey: .longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isAdmin, forKey: .isAdmin)
        try container.encode(namaMember, forKey: .namaMember )
        
        var nestedLocation = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
        
        try nestedLocation.encode(latitude, forKey: .latitude )
        try nestedLocation.encode(latitude, forKey: .longitude )
    }
    
}
struct HistoryMember : Codable {
    let member_Calorie:String?
    let member_Date:String?
    let member_Distance:String?
    let member_Pace:String?
    let time_Total:String?
    
    enum CodingKeys: String,CodingKey {
        case member_Calorie = "calorie"
        case member_Date = "date"
        case member_Distance = "distance"
        case member_pace = "pace"
        case time_total = "timeTotal"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        member_Calorie = try container.decode(String.self, forKey: .member_Calorie)
        member_Date = try container.decode(String.self, forKey: .member_Date)
        member_Distance = try container.decode(String.self, forKey: .member_Distance)
        member_Pace = try container.decode(String.self, forKey: .member_pace)
        time_Total = try container.decode(String.self, forKey: .time_total)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(member_Calorie, forKey: .member_Calorie)
        try container.encode(member_Date, forKey: .member_Date )
        try container.encode(member_Distance, forKey: .member_Distance)
        try container.encode(member_Pace, forKey: .member_pace )
        try container.encode(time_Total, forKey: .time_total)
      
    }
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
