//
//  LoginViewController.swift
//  ClockWork
//
//  Created by Mattis on 12.01.22.
//

import SwiftUI
import Firebase

struct LoginController {
    
    
    
    static func logIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void ) {
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
                    if let error = error{
                        guard let errorCode = AuthErrorCode(rawValue: error._code) else {
                            print(#file,#line, "Error error")
                            return
                        }
                        print(errorCode.errorMessage)
                        onError(errorCode.errorMessage)
                       return
                    } else {
                        onSuccess()
                    }
               }


    }
    static func signUpUser(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping (_ errorMessage : String) -> Void ) {
          Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
              if let error = error{
                  guard let errorCode = AuthErrorCode(rawValue: error._code) else {
                      print(#file,#line, "Error error")
                      return
                  }
                  print(errorCode.errorMessage)
                  onError(errorCode.errorMessage)
              } else {
                  onSuccess()
              }
             
        }
    }
}
