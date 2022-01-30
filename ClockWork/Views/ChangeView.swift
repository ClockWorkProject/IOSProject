//
//  ChangeView.swift
//  ClockWork
//
//  Created by Mattis on 21.12.21.
//

import SwiftUI

struct ChangeView: View {
    
    @ObservedObject var authentificationState =  AuthentificationObserver.shared
    

    
    var body: some View {
        Group {
            if authentificationState.isLoaded {
                if !authentificationState.isSignedIn {
                    LoginView()
                } else {
                    RootView()
                }
            } else {
                MiddleProgressView(color: Color.main)
            }
        }.onAppear(perform: listen)
    }
    
    func listen() {
        authentificationState.stateListener()
    }

}

