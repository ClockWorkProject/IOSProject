//
//  EmptyView.swift
//  ClockWork
//
//  Created by Mattis on 18.01.22.
// TODO: schöneres Design


import SwiftUI

struct EmptyProjectView: View {
    
    @State private var isShowingAlert = false
    @State private var alertInput = ""
    @ObservedObject var projectObserver : ProjectObserver

    var body: some View {
        Text("Für diese Gruppe gibt es noch keine Projekte. Sie können jetzt welche erstellen")
        Button(action: {
            withAnimation {
                self.isShowingAlert.toggle()
            }
        },
               label: {
            Text("Projekt erstellen")
                
                .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                .background(Color.main)
                .clipShape(Capsule())
                .padding([.leading, .trailing], 16)
                .padding([.bottom], 8)
                .padding([.top],32)
                .font(Font.system(size: 21, weight: .semibold))
                .foregroundColor(Color.white)
                
            
        })
            .textFieldAlert(isShowing: $isShowingAlert, placeholder: "Projkektname", title: "Projekt erstellen!", onAdd: addProject)
            .navigationBarTitle("Gruppe beitreten", displayMode: .inline)
    }
    func addProject(name: String) {
        if let groupID = AuthentificationObserver.shared.logdInUser?.groupID {
            projectObserver.createProject(name: name, groupId: groupID)
        }
        else {
            print("kein User")
        }
    }
}
