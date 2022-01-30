//
//  DatesObserver.swift
//  ClockWork
//
//  Created by Mattis on 22.01.22.
//

import Foundation
import Firebase
import FirebaseDatabaseSwift


final class DateObserver: ObservableObject {
    
    static let shared = DateObserver()
    let groupDB = Database.database().reference().child("groups")
    
    @Published var toggledDates: [ToggledDate] = []
    
    func observeDates(groupID: String) -> (UInt, UInt){
        guard let currentUser = Auth.auth().currentUser else {
            print("UserError")
            return (0, 0)
        }
        if !groupID.isEmpty {
            let handle = groupDB.child("\(groupID)/user/\(currentUser.uid)/dates").observe(.childAdded, with: { snapshot in
                    if let toggledDate = ToggledDate(snapshot: snapshot) {
                        //replace old data
                        if let index = self.toggledDates.firstIndex(where: { $0.dateString ==  toggledDate.dateString}) {
                            self.toggledDates[index] = toggledDate
                            self.toggledDates.sort{$0.dateString.localizedCompare($1.dateString) == .orderedDescending}
                        }
                        // if not exist
                        else if !self.toggledDates.contains(toggledDate) {
                            self.toggledDates.append(toggledDate)
                            self.toggledDates.sort{$0.dateString.localizedCompare($1.dateString) == .orderedDescending}
                        }
                        else {
                            print("contains")
                        }

                    } 
            })
            let updateHandler = groupDB.child("\(groupID)/user/\(currentUser.uid)/dates").observe(.childChanged, with: { snapshot in
                if let toggledDate = ToggledDate(snapshot: snapshot) {
                    if let index = self.toggledDates.firstIndex(where: { $0.dateString == toggledDate.dateString }) {
                        self.toggledDates[index] = toggledDate
                    }
                }
            })
            toggledDates.sort{$0.dateString.localizedCompare($1.dateString) == .orderedDescending}
            return (handle, updateHandler)
        }
        else {
            print(#file, "no groupID")
            return(0,0)
        }
    }
}
