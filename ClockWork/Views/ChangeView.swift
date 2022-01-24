//
//  ChangeView.swift
//  ClockWork
//
//  Created by Mattis on 21.12.21.
//

import SwiftUI

struct ChangeView: View {
    
    @ObservedObject var authentificationState =  AuthentificationObserver.shared
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some View {
        Group {
            if authentificationState.isLoaded {
                if !authentificationState.isSignedIn {
                    LoginView()
                } else {
                    CustomTabView(viewRouter: viewRouter)
                }
            } else {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                ProgressView()
                    .progressViewStyle(FullScreenProgressViewStyle())
                        Spacer()
                    }
                    Spacer()
                }.background(Color.main)
                    .ignoresSafeArea()
            }
        }.onAppear(perform: listen)
    }
    
    func listen() {
        authentificationState.stateListener()
    }

}

