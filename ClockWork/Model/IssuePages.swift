//
//  IssuePages.swift
//  ClockWork
//
//  Created by Mattis on 18.01.22.
//

import Foundation
import SwiftUI

enum IssuePages: String, CaseIterable, Codable {
    
    
    case open, todo, doing, review, blocker, closed
    
    var text: String {
        switch self {
        case .open:
            return "Open"
        case .todo:
            return "Todo"
        case .doing:
            return "Doing"
        case .review:
            return "Review"
        case .blocker:
            return "Blocker"
        case .closed:
            return "Closed"
        }
    }
    
    var color: Color{
        switch self {
        case .open:
            return Color.black
        case .todo:
            return Color.green
        case .doing:
            return Color.blue
        case .review:
            return Color.review
        case .blocker:
            return Color.red
        case .closed:
            return Color.black
        }
    }
}
