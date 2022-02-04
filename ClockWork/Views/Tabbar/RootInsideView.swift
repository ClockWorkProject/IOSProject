
//
//  ContentView.swift
//  CustomTabBar
//
// Von Blackbirds genommen und nach eigenen ansprüchen verändert
// https://blckbirds.com/post/custom-tab-bar-in-swiftui/

import SwiftUI
import Introspect

struct RootInsideView: View {
    
    @StateObject var viewRouter         = ViewRouter()
    @StateObject var stopwatchObserver  = Stopwatch()
    @StateObject var projectObserver    = ProjectObserver()
    @StateObject var dateObserver       = DateObserver()
    @StateObject var groupUserObserver  = GroupUserObserver()
    
    @ObservedObject var authObserver: AuthentificationViewModel
    
    var body: some View {
        // Wenn Nutzer in Gruppe
        if !(authObserver.logdInUser?.groupID?.isEmpty ?? true)  {
            NavigationView{
                GeometryReader { geometry in
                    //Views in dr Tabbar
                    VStack {
                        // Zeige View je nach geöffneter tab
                        // Wenn timer läuft zeige Timer über allen anderen Views an
                        if  stopwatchObserver.isRunning ?? false {
                            TimerView(stopwatch: stopwatchObserver)
                            Spacer()
                        }
                        // Switch Current Page
                        switch viewRouter.currentPage {
                        case .home:
                            ToggleView(dateObserver: dateObserver)
                        case .issueBoard:
                            IssueRootView(projectObserver: projectObserver)
                        case .statistic:
                            StatisticView(groupUserObserver: groupUserObserver)
                        case .user:
                            ProfilView(authObserver: authObserver, stopwatch: stopwatchObserver)
                        }
                        Spacer()
                        // Tabbbar
                        TabBarView(geometry: geometry,viewRouter: viewRouter, projectObserver: projectObserver, stopwatchObserver: stopwatchObserver)
                    }// Wenn erscheine suche überwache gruppen elemente
                    .onAppear(perform: {
                        if let  groupID = authObserver.logdInUser?.groupID, !groupID.isEmpty{
                            
                            projectObserver.observeProjects(groupID: groupID)
                            groupUserObserver.observeUser(groupID: groupID)
                            dateObserver.observeDates(groupID: groupID)
                        }
                    })
                }
                // Farbe NavigationBar
                .introspectNavigationController{ (UINavigatioController) in
                    UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
                    UINavigatioController.navigationBar.tintColor = UIColor.white
                    UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                }
            }
        }
        else {
            // Tab bar wenn in keine Gruppe
            TabView {
                NavigationView{
                    CreateGroupView()
                        .navigationBarTitle("Gruppe beitreten", displayMode: .inline)
                }
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Gruppe beitreten")
                }
                .introspectNavigationController{ (UINavigatioController) in
                    UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
                    UINavigatioController.navigationBar.tintColor = UIColor.white
                    UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                }
                NavigationView{
                    ProfilView(authObserver: authObserver)
                }
                .tabItem {
                    Image(systemName: "person")
                    Text("Profil")
                }
                .introspectNavigationController{ (UINavigatioController) in
                    UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
                    UINavigatioController.navigationBar.tintColor = UIColor.white
                    UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                }
            }
            
        }
        // introspect um die Topbar zufärben
    }
    
}



