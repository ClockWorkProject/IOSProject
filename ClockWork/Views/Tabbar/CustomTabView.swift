
//
//  ContentView.swift
//  CustomTabBar
//
// Created by BLCKBIRDS
// Visit BLCKBIRDS.COM FOR MORE TUTORIALS
import SwiftUI
import Introspect

struct CustomTabView: View {
    
    @StateObject var viewRouter: ViewRouter
    @ObservedObject var groupObserver = GroupObserver.shared
    @ObservedObject var stopwatchObserver = Stopwatch.shared
    
    @State var showPopUp = false
    @State var showingSheet = false
    
    var body: some View {
        NavigationView{
            if groupObserver.loading {
                ProgressView()
            }
            else {
            GeometryReader { geometry in
                VStack {
                    if  stopwatchObserver.isRunning ?? false {
                        TimerView()
                        Spacer()
                    }
                    switch viewRouter.currentPage {
                    case .home:
                        if groupObserver.hasGroup {
                            ToggleView()
                        }
                        else {
                            CreateGroupView()
                        }
                    case .liked:
                        IssueView()
                    case .records:
                        StatisticView()
                    case .user:
                        ProfilView()
                    }
                    Spacer()
                    ZStack {
                        HStack {
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .home, isDisabled: false, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "clock.arrow.circlepath", tabName: "Toggle")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .liked, isDisabled: !groupObserver.hasGroup, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "list.dash", tabName: "Issues")
                            ZStack {
                                Circle()
                                    .foregroundColor(Color.white)
                                    .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                    .shadow(radius: 4)
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width/7-6 , height: geometry.size.width/7-6)
                                    .foregroundColor(Color.main)
                                    .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                            }
                            .offset(y: -geometry.size.height/8/2)
                            .onTapGesture {
                                withAnimation {
                                    showingSheet = true                                }
                            }
                            .sheet(isPresented: $showingSheet) {
                                ToggleStartView()
                            }

                            TabBarIcon(viewRouter: viewRouter, assignedPage: .records, isDisabled: !groupObserver.hasGroup, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "chart.bar.xaxis", tabName: "Statistik")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .user, isDisabled: false, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.crop.circle", tabName: "Profil")
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height/8)
                        .background(Color.main.shadow(radius: 2))
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .introspectNavigationController{ (UINavigatioController) in
                        UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
                        UINavigatioController.navigationBar.tintColor = UIColor.white
                        UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                    }
            }
        }
        .onAppear(perform: listen)
        
        
    }
    
    
    func listen() {
        groupObserver.groupListener()
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: TabPage
    let isDisabled: Bool
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
        .padding(.horizontal, -4)
        .onTapGesture {
            if !isDisabled {
                viewRouter.currentPage = assignedPage
            }
        }
        .foregroundColor(viewRouter.currentPage == assignedPage ? Color.black : .white)
    }
}

