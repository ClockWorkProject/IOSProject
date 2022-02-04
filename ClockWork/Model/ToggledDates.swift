//
//  ToggledDates.swift
//  ClockWork
//
//  Created by Mattis on 22.01.22.
//

import Foundation
import Firebase

struct ToggledDate: Hashable {
    
    var dateString: String
    var totalTime: Double
    var toggledIssues: [ToggledIssue] = []
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let totalTime = Double(value["totalTime"] as? String ?? "0"),
            let issues = value["issues"] as? [String: AnyObject]
        else {
            print(#line,"wrongKeys")
            return nil
        }
        self.dateString = snapshot.key
        self.totalTime = totalTime

        issues.forEach {key, value in
            guard
                let issueName = value["issueName"] as? String,
                let projectName = value["projectName"] as? String,
                let issueTime = Double(value["issueTime"] as? String ?? "0")
            else {
                print(#line, "wrongKeys")
                return
                
            }
            toggledIssues.append(ToggledIssue(issueName: issueName, projectName: projectName, totalTime: issueTime))
            toggledIssues.sort{$0.projectName.localizedCompare($1.projectName) == .orderedAscending}
        }
        
    }
    
    func printPrettyTime() -> String {
        let (h,m,s) = (Int(totalTime) / 3600, (Int(totalTime) % 3600) / 60, (Int(totalTime) % 3600) % 60)
        return String(format: "%02d Std. %02d min.", h, m, s)
    }

}

struct ToggledIssue: Hashable{

    
    
    var issueName: String
    var projectName: String
    var totalTime: Double
    
    func printPrettyTime() -> String {
        let (h,m,s) = (Int(totalTime) / 3600, (Int(totalTime) % 3600) / 60, (Int(totalTime) % 3600) % 60)
        return String(format: "%02d Std. %02d min.", h, m, s)
    }
}
