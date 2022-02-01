//
//  IssueView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct ProfilView: View {
    
    @ObservedObject var authObserver : AuthentificationObserver
    
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Text("Benutzername:")
                .padding(8)
            Text (authObserver.logdInUser?.username ?? "")
                .padding(8)
            Button(action: {
                
            },
                   label: {
                Text("Info")
                
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                    .background(Color.main)
                    .clipShape(Capsule())
                    .padding([.leading, .trailing], 16)
                    .padding([.bottom], 8)
                    .padding([.top],32)
                    .font(Font.system(size: 21, weight: .semibold))
                    .foregroundColor(Color.white)
                
                
            })
            Button(action: {
                authObserver.logout()
            },
                   label: {
                Text("Ausloggen")
                
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                    .background(Color.main)
                    .clipShape(Capsule())
                    .padding([.leading, .trailing], 16)
                    .padding([.bottom], 8)
                    .padding([.top],32)
                    .font(Font.system(size: 21, weight: .semibold))
                    .foregroundColor(Color.white)
                
                
            })
            Spacer()
        }
    }
}

