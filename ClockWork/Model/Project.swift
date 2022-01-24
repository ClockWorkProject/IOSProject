//
//  Project.swift
//  ClockWork
//
//  Created by Mattis on 13.01.22.
//

import Foundation
import Firebase

struct Project: Hashable, Codable {
    
    var id: String
    var name: String
    var issues: [String: Issue]?
}

