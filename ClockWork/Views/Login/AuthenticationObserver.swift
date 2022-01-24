//
//  AuthenticationObserver.swift
//  ClockWork
//
//  Created by Mattis on 12.01.22.
//

import SwiftUI
import Firebase
import FirebaseDatabaseSwift
import Combine

final class AuthentificationObserver: ObservableObject {
    
    static let shared = AuthentificationObserver()
    let usersDB = Database.database().reference().child("user")
    
    @Published var isSignedIn = false
    @Published var isLoaded = false
    var username = ""
   
    
    
    var handle  : AuthStateDidChangeListenerHandle?
    
    func stateListener() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.usersDB.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if !snapshot.exists() {
                        FirebaseRepo.addUser(onSuccess: {username in
                            self.username = username
                            self.isSignedIn = true
                            print(self.isSignedIn)
                            }, onError: { (error) in
                                do {
                                    print(error)
                                    try Auth.auth().signOut()
                                    self.isLoaded = true
                                } catch {
                                    self.isLoaded = true
                                    self.isSignedIn = false
                                }
                                
                            })
                    } else {
                        guard
                            let value = snapshot.value as? [String: AnyObject],
                            let name = value["username"] as? String
                            //let dates = snapshot.childSnapshot(forPath: "dates")
                        else {
                            print(snapshot)
                            print(#file,#line,"wrongKeys")
                            return
                        }
                        self.username = name
                        print(self.username)
                        self.isSignedIn = true
                        self.isLoaded = true
                    }
             })
            } else {
                self.isSignedIn = false
                self.isLoaded = true
            }
        }
    }
}
