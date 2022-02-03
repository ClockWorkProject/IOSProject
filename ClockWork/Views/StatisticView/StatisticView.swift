//
//  StatisticView.swift
//  ClockWork
//
//  Created by Mattis on 22.01.22.
//

import SwiftUI

struct StatisticView: View {
    
    @ObservedObject var groupUserObserver : GroupUserObserver
    @State var showingSheet = false
    @State var groupUser: GroupUser? = nil
    @State private var handle: (UInt,UInt) = (0,0)
    
    var body: some View {
        VStack(alignment: .center) {
            if AuthentificationViewModel.shared.logdInUser?.admin ?? false{
                List(groupUserObserver.groupUsers, id: \.self) {groupUser in
                    Button(action: {
                        self.groupUser = groupUser
                        showingSheet = true
                    }, label: {
                        Text(groupUser.username)
                    })
                }.listStyle(.plain)
            } else {
                Spacer()
                Text("Wenn sie Admin sehen hier die Nutzerstatistike, die eigenen Statistiken sind gerade noch Work in Progress 🛠 kommen sie dafür bald wieder 😊")
                    .padding(16)
                Spacer()
            }
        }
        .navigationBarTitle("Statistiken", displayMode: .inline)
        .sheet(item: self.$groupUser) {item in
            NavigationView{
                ScrollView{
                    ForEach(item.toggledDates, id: \.self) {toggledDate in
                        CardView(toggledDate: toggledDate)
                    }
                }
                .navigationBarTitle(groupUser?.username ?? "", displayMode: .inline)
                .introspectNavigationController{ (UINavigatioController) in
                    UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
                    UINavigatioController.navigationBar.tintColor = UIColor.white
                    UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                }
            }
            
        }
    }
}

