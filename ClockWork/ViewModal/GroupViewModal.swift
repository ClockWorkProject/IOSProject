//
//  GroupViewModal.swift
//  ClockWork
//
//  Created by Mattis on 01.02.22.
//

import Foundation

final class GroupViewModel: ObservableObject {
    
    @Published var errorMessage: String?
    
    // Gruppe erstellen
    func addGroup(name: String) {
        if let user = AuthentificationViewModel.shared.logdInUser {
            FirebaseRepo.addGroup(user:  user, name: name, onSuccess: {groupID in
                AuthentificationViewModel.shared.logdInUser?.groupID = groupID
                AuthentificationViewModel.shared.logdInUser?.admin = true
            }, onError: {errorMessage in
                self.errorMessage = errorMessage
            })
        } else {
            print("Kein User angemeldet starten sie die App neu")
            errorMessage = "Kein User angemeldet starten sie die App neu"
        }
    }
    // Gruppe beitreten
    func enterGroup(groupID: String) {
        if let user = AuthentificationViewModel.shared.logdInUser {
            FirebaseRepo.enterGroup(user: user, groupID: groupID, onSuccess: { groupID in 
                AuthentificationViewModel.shared.logdInUser?.groupID = groupID
                AuthentificationViewModel.shared.logdInUser?.admin = false
                
            }, onError: {errorMessage in
                self.errorMessage = errorMessage
            })
        } else {
            errorMessage = "Kein User angemeldet starten sie die App neu"
        }
    }
    
}
