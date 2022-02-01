//
//  GroupViewModal.swift
//  ClockWork
//
//  Created by Mattis on 01.02.22.
//

import Foundation

final class GroupViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    
    func addGroup(name: String) {
        if let user = AuthentificationObserver.shared.logdInUser {
            FirebaseRepo.addGroup(user:  user, name: name, onSuccess: {groupID in
                AuthentificationObserver.shared.logdInUser?.groupID = groupID
                AuthentificationObserver.shared.logdInUser?.admin = true
            }, onError: {errorMessage in
                self.errorMessage = errorMessage
            })
        } else {
            print("Kein User angemeldet starten sie die App neu")
            errorMessage = "Kein User angemeldet starten sie die App neu"
        }
    }
    func enterGroup(groupID: String) {
        if let user = AuthentificationObserver.shared.logdInUser {
            FirebaseRepo.enterGroup(user: user, groupID: groupID, onSuccess: { groupID in 
                AuthentificationObserver.shared.logdInUser?.groupID = groupID
                AuthentificationObserver.shared.logdInUser?.admin = false
                
            }, onError: {errorMessage in
                self.errorMessage = errorMessage
            })
        } else {
            errorMessage = "Kein User angemeldet starten sie die App neu"
        }
    }
    
}
