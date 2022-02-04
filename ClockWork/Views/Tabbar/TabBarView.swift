//
//  TabBarView.swift
//  ClockWork
//
//  Created by Mattis on 30.01.22.
//

import SwiftUI

struct TabBarView: View {
    
    var geometry: GeometryProxy
    @ObservedObject var viewRouter: ViewRouter
    @State var hasGroup = true
    @State var showingSheet = false
    
    @ObservedObject var projectObserver : ProjectObserver
    @ObservedObject var stopwatchObserver : Stopwatch
    
    var body: some View {
        ZStack {
            HStack {
                // Toogle Icon
                TabBarIcon(viewRouter: viewRouter, assignedPage: .home, isDisabled: false, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "calendar.badge.clock", tabName: "Toggle")
                // IssueView nur klickbar wenn in Gruppe
                TabBarIcon(viewRouter: viewRouter, assignedPage: .issueBoard, isDisabled: !hasGroup, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "list.dash", tabName: "Issues")
                // wenn in Gruppe zeige Floatin Button
                if hasGroup {
                    ZStack {
                        // Floating Action Button
                        Circle()
                            .foregroundColor(Color.white)
                            .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                            .shadow(radius: 4)
                        Image(systemName: "clock.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: geometry.size.width/7-6 , maxHeight: geometry.size.width/7-6)
                            .foregroundColor(Color.main)
                            .rotationEffect(Angle(degrees: showingSheet ? 90 : 0))
                    }
                    .offset(y: -geometry.size.height/8/2)
                    .onTapGesture {
                        withAnimation {
                            showingSheet = true
                        }
                    }
                    //Sheet mit issues zum starten
                    .sheet(isPresented: $showingSheet) {
                        ToggleStartView(projectObserver: projectObserver, stopwatchObserver: stopwatchObserver)
                    }
                }
                // TStatistic View nur klickbar wenn in Gruppe
                TabBarIcon(viewRouter: viewRouter, assignedPage: .statistic, isDisabled: !hasGroup, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "chart.bar.xaxis", tabName: "Statistik")
                // ProfileView
                TabBarIcon(viewRouter: viewRouter, assignedPage: .user, isDisabled: false, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.crop.circle", tabName: "Profil")
            }
            // Größe der Bottomabar Höhe = Größe des Bildschirms/8
            .frame(width: geometry.size.width, height: geometry.size.height/8)
            // Farbe der BottomBar
            .background(Color.main.shadow(radius: 2))
        }
        // damit unten kein weißer Rand entsteht
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - TabBarIcon
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
        // Farbe wenn ausgewählt oder nicht
        .foregroundColor(viewRouter.currentPage == assignedPage ? Color.black : .white)
    }
}

