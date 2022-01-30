//
//  GroupListener.swift
//  ClockWork
//
//  Created by Mattis on 20.01.22.
//

import Foundation
import Firebase
import FirebaseDatabaseSwift
import Combine

final class GroupObserver: ObservableObject{
    
    static let shared = GroupObserver()
    
    let groupDB = Database.database().reference().child("groups")
    let usersDB = Database.database().reference().child("user")
    var groupID = ""
    
    @Published var hasGroup = false
    @Published var loading = true
    
    func groupListener() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        usersDB.child("\(currentUser.uid)").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return
          }
            let value = snapshot.value as? NSDictionary
            self.groupID = value?["groupID"] as? String ?? ""
            if self.groupID == "" {
                self.hasGroup = false
                self.loading = false
            }
            else {
                self.hasGroup = true
                self.loading = false
            }
        })
        
    }
}
