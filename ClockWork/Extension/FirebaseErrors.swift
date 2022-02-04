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
            return "Email exestiert bereits"
        case .userDisabled:
            return "Dein Account wurde gesperrt bitte kontaktieren sie den Support"
        case .invalidEmail:
            return "Bitte geben sie eine valide Emailadresse ein"
        case .networkError:
            return "Netztwerkfehler. Bitte versuchen sie es nochmal"
        case .weakPassword:
            return "Passwort zu schwach. Bitte nutzen sie min 6 Zeichen"
        case .wrongPassword:
            return "Ungültige Email/Passwort"
        case .userNotFound:
            return "Ungültige Email/Passwort"
        default:
            return "Ungewöhnlicher Fehler versuchen sie es nochmal"
        }
    }
}

