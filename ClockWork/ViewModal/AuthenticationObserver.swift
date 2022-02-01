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
    let groupDB = Database.database().reference().child("groups")
    
    @Published var email = ""
    @Published var logdInUser: User?
    @Published var loginState: LoginState = .loading
    
    func loginListener() {
       Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.usersDB.child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if !snapshot.exists() {
                        self.addUser()
                    } else {
                        self.loadUser(snapshot: snapshot)
                    }
             })
            } else {
                self.loginState = .loggedOut
            }
        }
    }
    
    func loadUser(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["username"] as? String,
            let groupID = value["groupID"] as? String
        else {
            self.loginState = .error("Fehler beim laden des Users. Sie wurden ausgeloggt")
            return
        }
        self.logdInUser = User(id: snapshot.key, username: name, groupID: groupID)
        if !groupID.isEmpty{
            groupDB.child("\(groupID)/user/\(snapshot.key)").getData(completion:  { error, snapshot in
                if let error = error {
                    self.loginState = .error(error.localizedDescription)
                } else {
                    guard
                        let value = snapshot.value as? [String: AnyObject],
                        let role  = value["role"] as? String
                    else {
                        self.loginState = .error("Falscher Key bitte support anschreiben")
                        return
                    }
                    self.logdInUser?.admin = role == "admin"
                    self.loginState = .loggedIn
                }
            })
        }
        else {
            loginState = .loggedIn
        }
        
    }
    
    func logIn(password: String ) {
        self.email = email
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
                    if let error = error{
                        guard let errorCode = AuthErrorCode(rawValue: error._code) else {
                            print(#file,#line, "Error error")
                            return
                        }
                        self.loginState = .error(errorCode.errorMessage)
                       return
                    }
               }


    }
    func signUpUser(password: String) {
          Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
              if let error = error{
                  guard let errorCode = AuthErrorCode(rawValue: error._code) else {
                      print(#file,#line, "Error error")
                      return
                  }
                  self.loginState = .error(errorCode.errorMessage)
              }
             
        }
    }
    
    func addUser() {
        FirebaseRepo.addUser(onError: {errorMessage in
            self.loginState = .error(errorMessage)
        }, onSuccess: {user in
            self.logdInUser = user
            self.loginState = .loggedIn
        })
    }
    
    func logout() {
        do {
            loginState = .loggedOut
            try Auth.auth().signOut()
        } catch {
            
        }
            
    }
    
}
