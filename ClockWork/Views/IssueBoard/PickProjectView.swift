//
//  PickProjectView.swift
//  ClockWork
//
//  Created by Mattis on 18.01.22.
//

import SwiftUI

struct PickView: View {
    @Binding var picked : String
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowing = false
    @State var text = ""
    @ObservedObject var projectObserver = ProjectObserver.shared
    @State var listenhandler : (UInt, UInt) = (0,0)
    
    
    var body: some View {
        VStack {
            if isShowing {
                MakeProjectView(isShowing: $isShowing)
                    .navigationBarTitle("Projekt erstellen")
            }
           else {
                List {
                    ForEach(projectObserver.projects, id: \.self){ project in
                        Button(action: {
                            projectObserver.savedProject =  project
                            UserDefaults.standard.set(project.id,forKey: "savedProjectId")
                            projectObserver.issues = []
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("\(project.name)")
                                .foregroundColor(Color.black)
                        }
                    }
                }.onAppear(perform: listen)
                   .onDisappear(perform: unlisten)
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
    // MARK: - Function
    func listen() {
        projectObserver.projectListener()
    }
    func unlisten() {
        
    }
    
}


// MARK: - MakeProjectView
// Workaround weil bei alert lassen sich die Button auf dem ParentView nicht pressen.
struct MakeProjectView: View {
    
    @State var input = ""
    @Binding var isShowing: Bool
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
                    let groupID = GroupObserver.shared.groupID
                    FirebaseRepo.addProjectToGroup(groupID: groupID, name: input, onSuccess: {
                        withAnimation {
                            self.isShowing.toggle()
                        }
                    }, onError: {errorMessage in
                        
                    })

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
