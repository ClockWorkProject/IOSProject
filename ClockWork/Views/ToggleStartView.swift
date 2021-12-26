//
//  ToggleStartView.swift
//  ClockWork
//
//  Created by Mattis on 23.12.21.
//

import SwiftUI
import Introspect

struct MyGroup {
    var name:String, items:[String]
}


struct ToggleStartView: View {
    
    var groups : [MyGroup] = [
            .init(name: "Animals", items: ["🐕","🐩","🐂","🐄","🐈","🦩","🐿","🐇"]),
            .init(name: "Vehicles", items: ["🚕","🚗","🚃","🚂","🚟","🚤","🛥","⛵️"])]
    
    var body: some View {
        NavigationView {
                    VStack {
                        List {
                            ForEach(groups, id: \.self.name) { group in
                                Section(header: Text(group.name)) {
                                    ForEach(group.items, id:\.self) { item in
                                        Text(item)
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

struct TaskRow: View {
    var body: some View {
        Text("Task data goes here")
    }
}
