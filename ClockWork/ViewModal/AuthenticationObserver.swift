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

final class AuthentificationViewModel: ObservableObject {
    
    static let shared = AuthentificationViewModel()
    let usersDB = Database.database().reference().child("user")
    let groupDB = Database.database().reference().child("groups")
    
    @Published var email = ""
    @Published var logdInUser: User?
    @Published var loginState: LoginState = .loading
    
    
    // Überwacht Authentifizierung.
    func loginListener() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // Wenn eingeloggt wird der User aus Datenbank aufgerufen:
                self.usersDB.child(user.uid).observe( .value, with: { (snapshot) in
                    // wenn Nutzer noch nicht exestiert
                    if !snapshot.exists() {
                        self.addUser()
                    } else {
                        // Wenn Nutzer schon exestiert
                        self.loadUser(snapshot: snapshot)
                    }
                })
                //Wenn ausgeloggt state loggout
            } else {
                self.loginState = .loggedOut
            }
        }
    }
    
    
    
    //MARK: - Login
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
    //MARK: - SignUp
    func signUpUser(password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
            if let error = error{
                // Läd die ErrorMessage aus der App
                guard let errorCode = AuthErrorCode(rawValue: error._code) else {
                    print(#file,#line, "Error error")
                    return
                }
                self.loginState = .error(errorCode.errorMessage)
            }
            
        }
    }
    //MARK: - LogOut
    func logout(stopwatch: Stopwatch?) {
        do {
            stopwatch?.stop()
            try Auth.auth().signOut()
            logdInUser = nil
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
        } catch {
            
        }
        
    }
    
    // MARK: - LoadUser
    private func loadUser(snapshot: DataSnapshot) {
        
        // baut den User aus dem snapshot
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["username"] as? String,
            let groupID = value["groupID"] as? String
        else {
            // Wenn Keys falsch bennant wurden
            self.loginState = .error("Fehler beim Laden des Users. Sie wurden ausgeloggt")
            return
        }
        self.logdInUser = User(id: snapshot.key, username: name, groupID: groupID)
        // Wenn User in Guppe lade Rolle
        if !groupID.isEmpty{
            groupDB.child("\(groupID)/user/\(snapshot.key)").getData(completion:  { error, snapshot in
                if let error = error {
                    self.loginState = .error(error.localizedDescription)
                } else {
                    guard
                        let value = snapshot.value as? [String: AnyObject],
                        let role  = value["role"] as? String
                    else {
                        // Wenn key falsch benannt wurde
                        self.loginState = .error("Falscher Key bitte support anschreiben")
                        return
                    }
                    // überprüft ob user admin ist und Logge ein
                    self.logdInUser?.admin = role == "admin"
                    self.loginState = .loggedIn
                }
            })
        }
        else {
            //Log ein wenn in keiner Gruppe
            loginState = .loggedIn
        }
        
    }
    
    //MARK: - AddUser
    // Ruft Add User aus der Repo auf
    private func addUser() {
        FirebaseRepo.addUser(onError: {errorMessage in
            self.loginState = .error(errorMessage)
        }, onSuccess: {user in
            // Logge ein und setze user
            self.logdInUser = user
            self.loginState = .loggedIn
        })
    }
    
}
