//
//  FirebaseErrora.swift
//  ClockWork
//
//  Created by Mattis on 24.01.22.
//

import Foundation
import Firebase

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Passwort zu schwach. Bitte nutzen sie min 6 Zeichen"
        case .wrongPassword:
            return "Ungültige Email/Passwort"
        case .userNotFound:
            return "Ungültige Email/Passwort"
        default:
            return "Unknown error occurred"
        }
    }
}

