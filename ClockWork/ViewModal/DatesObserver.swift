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

    // DateFormatter zum vergeleichen
    private let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    private var ref = Database.database().reference().child("groups")
    private var newDateHandle: UInt = 0
    private var updateHandle: UInt = 0
    
    @Published var toggledDates: [ToggledDate] = []
    
    //Observ Child Added
    func observeDates(groupID: String) {
        guard let currentUser = Auth.auth().currentUser else {
            print("UserError")
            return
        }
        if !groupID.isEmpty {
            ref = ref.child("\(groupID)/user/\(currentUser.uid)/dates")
            newDateHandle = ref.observe(.childAdded, with: {  snapshot in
                    if let toggledDate = ToggledDate(snapshot: snapshot) {
                        //replace old data
                        if let index = self.toggledDates.firstIndex(where: { $0.dateString ==  toggledDate.dateString}) {
                            self.toggledDates[index] = toggledDate
                            // Sortier Array nach Datum neustes zuerst
                            self.toggledDates = self.toggledDates.sorted(by: {(date0,date1) -> Bool in
                                return self.dateFormatter.date(from: date0.dateString) ?? Date() > self.dateFormatter.date(from: date1.dateString) ?? Date()
                            })
                        }
                        // if not exist
                        else if !self.toggledDates.contains(toggledDate) {
                            self.toggledDates.append(toggledDate)
                            // Sortier Array nach Datum neustes zuerst
                            self.toggledDates = self.toggledDates.sorted(by: {(date0,date1) -> Bool in
                                return self.dateFormatter.date(from: date0.dateString) ?? Date() > self.dateFormatter.date(from: date1.dateString) ?? Date()
                            })
                        }
                        else {
                            print("contains")
                        }

                    }
            })
            updateHandle = ref.child("\(groupID)/user/\(currentUser.uid)/dates").observe(.childChanged, with: { snapshot in
                if let toggledDate = ToggledDate(snapshot: snapshot) {
                    if let index = self.toggledDates.firstIndex(where: { $0.dateString == toggledDate.dateString }) {
                        self.toggledDates[index] = toggledDate
                        self.toggledDates = self.toggledDates.sorted(by: {(date0,date1) -> Bool in
                            return self.dateFormatter.date(from: date0.dateString) ?? Date() > self.dateFormatter.date(from: date1.dateString) ?? Date()
                        })
                    }
                }
            })
        }
        else {
            print(#file, "no groupID")
        }
    }
    
    deinit {
        print("removeIssueListener")
        ref.removeObserver(withHandle: updateHandle)
        ref.removeObserver(withHandle: newDateHandle)
    }
}
