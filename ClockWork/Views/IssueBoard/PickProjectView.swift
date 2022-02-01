//
//  PickProjectView.swift
//  ClockWork
//
//  Created by Mattis on 18.01.22.
//  https://stackoverflow.com/a/57585807

import SwiftUI

struct PickView: View {

    @Environment(\.presentationMode) var presentationMode
    @State private var isShowing = false
    @ObservedObject var projectObserver : ProjectObserver

    
    
    var body: some View {
        VStack {
            if isShowing {
                MakeProjectView(isShowing: $isShowing, projectObserver: projectObserver)
                    .navigationBarTitle("Projekt erstellen")
            }
           else {
                List {
                    ForEach(projectObserver.projects, id: \.self){ project in
                        Button(action: {
                            projectObserver.savedProject =  project
                            UserDefaults.standard.set(project.id,forKey: "savedProjectId")
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("\(project.name)")
                                .foregroundColor(Color.black)
                        }
                    }
                }
                .navigationBarTitle("Projekte")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) { Button(action:
                                                                                {
                        isShowing.toggle()
                    }) {
                        Image(systemName: "plus")
                            .frame(height: 96, alignment: .trailing) // Workaroud, credit: https://stackoverflow.com/a/62209223/5421557
                        
                    }
                    }
                }
           }
        }
    }
}


// MARK: - MakeProjectView
// Workaround weil bei alert lassen sich die Button auf dem ParentView nicht pressen.
struct MakeProjectView: View {
    
    @State var input = ""
    @Binding var isShowing: Bool
    @ObservedObject var projectObserver: ProjectObserver
    let borderColor = Color.text.opacity(0.35)
    
    var body: some View {
        
        VStack {
            Spacer()
            TextField("Projektname", text: $input)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 24)
                .padding(8)
                .foregroundColor(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 1)
                )
                .padding([.bottom], 8)
                .padding([.top],32)
                .padding([.leading, .trailing], 16)
            Button(action: {
                withAnimation {
                    if let groupID = AuthentificationObserver.shared.logdInUser?.groupID {
                        projectObserver.createProject(name: input, groupId: groupID)
                        isShowing.toggle()
                    }
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
            
            Button(action: {
                withAnimation {
                    self.isShowing.toggle()
                }
            },
                   label: {
                Text("Abbrechen")
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
        .navigationBarItems(trailing: Button(action:
                                                {
        }) {
           Text("")
            
        })
    }
}
