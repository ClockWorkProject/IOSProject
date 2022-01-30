
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
    @StateObject var groupObserver      = GroupObserver.shared
    @StateObject var stopwatchObserver  = Stopwatch.shared
    @StateObject var projectObserver    = ProjectObserver.shared
    @StateObject var dateObserver       = DateObserver.shared
    
    var body: some View {
        NavigationView{
            // Warte bis Gruppe geladen ist
            if groupObserver.loading {
                MiddleProgressView(color: Color.main)
            }
            else {
                GeometryReader { geometry in
                    //Views in dr Tabbar
                    VStack {
                        // Wenn timer läuft zeige Timer über allen anderen Views an
                        if  stopwatchObserver.isRunning ?? false {
                            TimerView()
                            Spacer()
                        }
                        // Zeige View je nach geöffneter tab
                        switch viewRouter.currentPage {
                        case .home:
                            //Wenn in Gruppe öffne Tages Statistiken
                            if groupObserver.hasGroup {
                                ToggleView()
                            }
                            else {
                                //sonst zeige gruppe erstellen/beitreten Bildschirm
                                CreateGroupView()
                            }
                        case .issueBoard:
                            IssueRootView(projectObserver: projectObserver)
                        case .statistic:
                            StatisticView()
                        case .user:
                            ProfilView()
                        }
                        Spacer()
                        // Tabbbar
                        TabBarView(geometry: geometry, viewRouter: viewRouter, hasGroup: groupObserver.hasGroup)
                    }
                    // introspect um die Topbar zufärben
                }
            }
        }
        .introspectNavigationController{ (UINavigatioController) in
            UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
            UINavigatioController.navigationBar.tintColor = UIColor.white
            UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
        }
        .onChange(of:  groupObserver.hasGroup, perform: {hasGroup in
            print("change")
            if hasGroup {
                dateObserver.observeDates(groupID: groupObserver.groupID)
                projectObserver.observeProjects(groupID: groupObserver.groupID)
            }
        })
        .onAppear(perform:  {
            groupObserver.groupListener()
        })
        
    }
}

