//
//  CreateGroupView.swift
//  ClockWork
//
//  Created by Mattis on 17.01.22.
//

import SwiftUI

struct CreateGroupView: View {
    
    @State private var isShowingCreateAlert = false
    @State private var isShowingEnterAlert = false
    @State private var alertInput = ""
    
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
        }.textFieldAlert(isShowing: $isShowingCreateAlert, placeholder: "Gruppenname" ,title: "Gruppe erstellen!", onAdd: addGroup)
            .textFieldAlert(isShowing: $isShowingEnterAlert, placeholder: "Gruppenid" ,title: "Gruppe erstellen!", onAdd: enterGroup)
            .navigationBarTitle("Gruppe beitreten", displayMode: .inline)
        
    }
    func addGroup(name: String) {
        FirebaseRepo.addGroup(name: name, onSuccess: {
            GroupObserver.shared.groupListener()
            
        }, onError: {errorMessage in
            print(errorMessage)
        })
    }
    func enterGroup(groupID: String) {
        FirebaseRepo.enterGroup(groupID: groupID, onSuccess: {
            GroupObserver.shared.groupListener()
            
        }, onError: {errorMessage in
            print(errorMessage)
        })
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
    }
}
