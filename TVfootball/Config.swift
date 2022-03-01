//
//  Sports.swift
//  TVfootball
//
//  Created by Денис on 10.02.2022.
//

import Foundation

struct SportType {
    var key: String
    var name: String
    var search: String
}

struct Config {
    static let sports = [
        SportType(key: "isFootball", name: "Футбол",         search: "Футбол"),
        SportType(key: "isBiathlon", name: "Биатлон",        search: "Биатлон"),
        //SportType(key: "isOlympic",  name: "Олимпиада 2022", search: "Олимпийские игры")
    ]
}
