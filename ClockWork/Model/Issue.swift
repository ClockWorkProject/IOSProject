//
//  Issue.swift
//  ClockWork
//
//  Created by Mattis on 13.01.22.
//

import Foundation

struct Issue: Codable, Hashable {
    
    var name: String
    var id : String = ""
    var number: String
    var description: String?
    var issueState: IssuePages
}
