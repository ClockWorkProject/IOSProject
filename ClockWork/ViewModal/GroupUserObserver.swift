//
//  GroupUserObserver.swift
//  ClockWork
//
//  Created by Mattis on 22.01.22.
//

import Foundation
import Firebase

final class GroupUserObserver: ObservableObject {
    
    let groupDB = Database.database().reference().child("groups")
    
    private var ref = Database.database().reference().child("groups")
    private var newUserHandle: UInt = 0
    private var updateHandle: UInt = 0
    
    @Published var groupUsers : [GroupUser] = []
    
    func observeUser(groupID: String) {
        if !groupID.isEmpty {
            print("Observe groupUser")
            ref = ref.child("\(groupID)/user/")
            newUserHandle = ref.observe(.childAdded, with: { snapshot in
                
                if let groupUser = GroupUser(snapshot: snapshot) {
                    //replace old data
                    if let index = self.groupUsers.firstIndex(where: { $0.id ==  groupUser.id}) {
                        self.groupUsers[index] = groupUser
                    }
                    // if not exist
                    else if !self.groupUsers.contains(groupUser) {
                        self.groupUsers.append(groupUser)
 
                    }
                    else {
                        print("contains")
                    }
                    print(self.groupUsers)
                }
            })
            updateHandle = ref.observe(.childChanged, with: { snapshot in
                if let groupUser = GroupUser(snapshot: snapshot) {
                    if let index = self.groupUsers.firstIndex(where: { $0.id == groupUser.id }) {
                        self.groupUsers[index] = groupUser
                    }
                }
            })

        }
        else {
            print("no groupID")
        }
    }
    
    deinit {
        print("removeDateListener")
        ref.removeObserver(withHandle: updateHandle)
        ref.removeObserver(withHandle: newUserHandle)
    }
}
