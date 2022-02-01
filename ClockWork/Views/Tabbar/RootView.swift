
//
//  ContentView.swift
//  CustomTabBar
//
// Von Blackbirds genommen und nach eigenen ansprüchen verändert
// https://blckbirds.com/post/custom-tab-bar-in-swiftui/

import SwiftUI
import Introspect

struct RootView: View {
    
    @StateObject var viewRouter         = ViewRouter()
    @StateObject var stopwatchObserver  = Stopwatch()
    @StateObject var projectObserver    = ProjectObserver()
    @StateObject var dateObserver       = DateObserver()
    @StateObject var groupUserObserver  = GroupUserObserver()
    
    
    @ObservedObject var authObserver: AuthentificationObserver
    
    var body: some View {
        NavigationView{
            // Warte bis Gruppe geladen ist
                GeometryReader { geometry in
                    //Views in dr Tabbar
                    VStack {
                        // Wenn timer läuft zeige Timer über allen anderen Views an
                        if  stopwatchObserver.isRunning ?? false {
                            TimerView(stopwatch: stopwatchObserver)
                            Spacer()
                        }
                        // Zeige View je nach geöffneter tab
                        if !(authObserver.logdInUser?.groupID?.isEmpty ?? true)  {
                        switch viewRouter.currentPage {
                        case .home:
                            ToggleView(dateObserver: dateObserver)
                        case .issueBoard:
                            IssueRootView(projectObserver: projectObserver)
                        case .statistic:
                            StatisticView(groupUserObserver: groupUserObserver)
                        case .user:
                            ProfilView(authObserver: authObserver)
                        }
                            Spacer()
                        }
                        
                        // Tabbbar
                        if !(authObserver.logdInUser?.groupID?.isEmpty ?? true)  {
                            TabBarView(geometry: geometry,viewRouter: viewRouter, projectObserver: projectObserver, stopwatchObserver: stopwatchObserver)
                        }
                        else {
                            TabView {
                                CreateGroupView()
                                    .tabItem {
                                        Image(systemName: "group")
                                        Text("First Tab")
                                    }
                                ProfilView(authObserver: authObserver)
                                    .tabItem {
                                        Image(systemName: "person")
                                        Text("First Tab")
                                    }
                            }
                        }
                    }
                    // introspect um die Topbar zufärben
                }
        }
        .introspectNavigationController{ (UINavigatioController) in
            UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
            UINavigatioController.navigationBar.tintColor = UIColor.white
            UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        }
        .onAppear(perform: {
            if let  groupID = authObserver.logdInUser?.groupID, !groupID.isEmpty{
                dateObserver.observeDates(groupID: groupID)
                projectObserver.observeProjects(groupID: groupID)
                groupUserObserver.observeUser(groupID: groupID)
            }
        })
        .onChange(of:  authObserver.logdInUser, perform: {user in
            print("change")
            if let groupID = user?.groupID, !groupID.isEmpty{
                dateObserver.observeDates(groupID: groupID)
                projectObserver.observeProjects(groupID: groupID)
                groupUserObserver.observeUser(groupID: groupID)
            }
        })
    }
}

