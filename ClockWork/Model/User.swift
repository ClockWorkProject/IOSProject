//
//  User.swift
//  ClockWork
//
//  Created by Mattis on 13.01.22.
//

import Foundation

struct User: Codable, Equatable {
    
    var id: String
    var username: String
    var groupID: String?
    var admin: Bool?
}
