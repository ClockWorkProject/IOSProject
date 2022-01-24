//
//  GroupUser.swift
//  ClockWork
//
//  Created by Mattis on 22.01.22.
//

import Foundation
import Firebase

struct GroupUser: Hashable, Identifiable {

    var id : String
    //var name: String
    var username: String
    var toggledDates: [ToggledDate] = []
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String
            //let dates = snapshot.childSnapshot(forPath: "dates")
        else {
            print(#file,#line,"wrongKeys")
            return nil
        }
        self.id = snapshot.key
        self.username = name
        let dates = snapshot.childSnapshot(forPath: "dates")
        for child in dates.children {
            guard let child = child as? DataSnapshot else {
                print("kein dates")
                return
            }
            if let date = ToggledDate(snapshot: child) {
                toggledDates.append(date)
            }
        }
    }
    
}
