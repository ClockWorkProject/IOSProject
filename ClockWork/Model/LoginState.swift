//
//  StateMachine.swift
//  ClockWork
//
//  Created by Mattis on 01.02.22.
//

import Foundation


enum LoginState {
    case loading, loggedIn, loggedOut, error(String)
}



