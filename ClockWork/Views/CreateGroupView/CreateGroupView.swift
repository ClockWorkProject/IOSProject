//
//  CreateGroupView.swift
//  ClockWork
//
//  Created by Mattis on 17.01.22.
// TODO: Design

import SwiftUI

struct CreateGroupView: View {
    
    @State private var isShowingCreateAlert = false
    @State private var isShowingEnterAlert = false
    @State private var alertInput = ""
    @ObservedObject var groupViewModel = GroupViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            Text("Sie sind noch in keiner Gruppe bitte tretten sie einer bei oder erstellen Sie eine")
            Button(action: {
                withAnimation {
                    self.isShowingCreateAlert = true
                }
            },
                   label: {
                Text("Gruppe erstellen")
                
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
                withAnimation {
                    self.isShowingEnterAlert = true
                }
            },
                   label: {
                Text("Gruppe beitreten")
                
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
        }.textFieldAlert(isShowing: $isShowingCreateAlert, placeholder: "Gruppenname" ,title: "Gruppe erstellen!", onAdd: groupViewModel.addGroup(name:))
            .textFieldAlert(isShowing: $isShowingEnterAlert, placeholder: "Gruppenid" ,title: "Gruppe erstellen!", onAdd: groupViewModel.enterGroup(groupID:))
            .navigationBarTitle("Gruppe beitreten", displayMode: .inline)
        
    }
}
