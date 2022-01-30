//
//  ToggleStartView.swift
//  ClockWork
//
//  Created by Mattis on 23.12.21.
//

import SwiftUI
import Introspect

struct ToggleStartView: View {
    
    @ObservedObject var projectObserver = ProjectObserver.shared
    @ObservedObject var stopwatchObserver = Stopwatch.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
                    VStack {
                        List {
                            ForEach(projectObserver.projects, id: \.self.id) { project in
                                Section(header: Text(project.name)) {
                                    ForEach(project.issues, id: \.self) { item in
                                        Button {
                                            // startet die Stoppuhr und schließt sheet
                                            stopwatchObserver.issue = item
                                            stopwatchObserver.project = project
                                            stopwatchObserver.start()
                                            presentationMode.wrappedValue.dismiss()
                                        } label: {
                                            Text(item.name)
                                        }
                                    }
                                }
                            }
                            
                        } .listStyle(SidebarListStyle())
                    }
                    .navigationBarTitle("Toogle starten", displayMode: .inline)
                    .introspectNavigationController{ (UINavigatioController) in
                                UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
                                UINavigatioController.navigationBar.tintColor = UIColor.white
                                UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                            }
                }

    }
}

struct ToggleStartView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleStartView()
    }
}
