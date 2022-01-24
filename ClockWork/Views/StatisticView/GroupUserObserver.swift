//
//  GroupUserObserver.swift
//  ClockWork
//
//  Created by Mattis on 22.01.22.
//

import Foundation
import Firebase

final class GroupUserObserver: ObservableObject {
    
    static let shared = GroupUserObserver()
    private let groupID = GroupObserver.shared.groupID
    let groupDB = Database.database().reference().child("groups")
    
    @Published var groupUsers : [GroupUser] = []
    
    func observeUser() -> (UInt, UInt){
        guard let currentUser = Auth.auth().currentUser else {
            print("UserError")
            return (0, 0)
        }
        if !groupID.isEmpty {
            print("Observe groupUser")
            let handle = groupDB.child("\(groupID)/user/").observe(.childAdded, with: { snapshot in
                
                if let groupUser = GroupUser(snapshot: snapshot) {
                    //replace old data
                    if let index = self.groupUsers.firstIndex(where: { $0.id ==  groupUser.id}) {
                        self.groupUsers[index] = groupUser
             //           self.toggledDates.sort{$0.dateString.localizedCompare($1.dateString) == .orderedDescending}
                    }
                    // if not exist
                    else if !self.groupUsers.contains(groupUser) {
                        self.groupUsers.append(groupUser)
                        //self.groupUsers.sort{$0.dateString.localizedCompare($1.dateString) == .orderedDescending}
                    }
                    else {
                        print("contains")
                    }
                    print(self.groupUsers)
                }
            })
            let updateHandler = groupDB.child("\(groupID)/user/\(currentUser.uid)/dates").observe(.childChanged, with: { snapshot in
                if let groupUser = GroupUser(snapshot: snapshot) {
                    if let index = self.groupUsers.firstIndex(where: { $0.id == groupUser.id }) {
                        self.groupUsers[index] = groupUser
                    }
                }
            })
            //toggledDates.sort{$0.dateString.localizedCompare($1.dateString) == .orderedDescending}
            return (handle, updateHandler)
        }
        else {
            print("no groupID")
            return(0,0)
        }
    }
}
