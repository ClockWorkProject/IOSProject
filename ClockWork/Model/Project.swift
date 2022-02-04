//
//  Project.swift
//  ClockWork
//
//  Created by Mattis on 13.01.22.
//

import Foundation
import Firebase

struct Project: Hashable, Codable, Identifiable {
    internal init(id: String = "", name: String = "", issues: [Issue] = []) {
        self.id = id
        self.name = name
        self.issues = issues
    }
    
    
    var id: String = ""
    var name: String = ""
    var issues: [Issue] = []
    
    
    // erstellt aus Snapchot ein Projekt wenn nicht gibt er nil zurück
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String
        else {
            print(#file,#line,"wrongKeys")
            return nil
        }
        self.id = snapshot.key
        self.name = name
        
        if let issues = value["issues"] as? [String: AnyObject] {
            issues.forEach {key, value in
                guard
                    let issueName   = value["name"] as? String,
                    let issueState  = value["issueState"] as? String,
                    let issueNumber = value["number"] as? String,
                    let issueDescrption = value["description"] as? String
                else {
                    print(#file,#line, "wrongKeys")
                    return
                }
                self.issues.append(Issue(name: issueName, id: key, number: issueNumber, description: issueDescrption, issueState: IssuePages(rawValue: issueState) ?? .open))
            }
            self.issues.sort{$0.number.localizedCompare($1.number) == .orderedAscending}
        }
    }
}

