//
//  ChangeView.swift
//  ClockWork
//
//  Created by Mattis on 21.12.21.
//

import SwiftUI

struct RootView: View {
    
    @StateObject var userViewModal =  AuthentificationObserver.shared
    
    
    // Start der App. Prüft ob der User eingelogt wird und zeigt dann die innere App.
    var body: some View {
        Group {
            switch userViewModal.loginState  {
            case .loggedOut:
                LoginView(userViewModel: userViewModal)
            case .loading:
                MiddleProgressView(color: Color.main)
            case .loggedIn:
                RootInsideView(authObserver: userViewModal)
            case let .error(errorMessage):
                LoginView(userViewModel: userViewModal)
                    .alert(isPresented: .constant(true) , content: {
                        Alert(title: Text("Fehler"), message: Text(errorMessage), dismissButton:  .default(Text("Okay"), action: {
                            userViewModal.loginState = .loggedOut
                        }))
                    })
            }
                
        }.onAppear(perform: listen)
    }
    
    func listen() {
        userViewModal.loginListener()
    }

}

