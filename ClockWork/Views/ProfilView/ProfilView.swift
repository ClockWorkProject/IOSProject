//
//  IssueView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct ProfilView: View {
    
    @ObservedObject var authObserver : AuthentificationViewModel
    var stopwatch : Stopwatch?
    @State var isShowing = false
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            // Benutzername
            Text("Benutzername:")
                .font(.title2)
            Text (authObserver.logdInUser?.username ?? "")
                .font(.title2)
            
            Button(action: {
                isShowing.toggle()
            },
                   label: {
                Text("Info")
                
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                    .background(Color.main)
                    .clipShape(Capsule())
                    .padding([.leading, .trailing], 16)
                    .padding([.bottom], 16)
                    .padding([.top],32)
                    .font(Font.system(size: 21, weight: .semibold))
                    .foregroundColor(Color.white)
                
                
            })
            // Ausloggen
            Button(action: {
                authObserver.logout(stopwatch: stopwatch)
            },
                   label: {
                Text("Ausloggen")
                
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                    .background(Color.main)
                    .clipShape(Capsule())
                    .padding([.leading, .trailing], 16)
                    .padding([.bottom], 8)
                    .font(Font.system(size: 21, weight: .semibold))
                    .foregroundColor(Color.white)
                
                
            })
            Spacer()
        }
        .navigationBarTitle("Profil", displayMode: .inline)
        .sheet(isPresented: $isShowing) {
            LicenceView()
        }
    }
}

