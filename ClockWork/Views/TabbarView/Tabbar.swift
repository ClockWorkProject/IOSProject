
//
//  ContentView.swift
//  CustomTabBar
//
// Created by BLCKBIRDS
// Visit BLCKBIRDS.COM FOR MORE TUTORIALS
import SwiftUI
import Introspect

struct TabView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    @State var showPopUp = false
    @State var showingSheet = false
    
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    switch viewRouter.currentPage {
                    case .home:
                        ToggleView()
                    case .liked:
                        IssueView()
                    case .records:
                        StatisticView()
                    case .user:
                        ProfilView()
                    }
                    Spacer()
                    ZStack {
                        if showPopUp {
                            PlusMenu(widthAndHeight: geometry.size.width/7)
                                .offset(y: -geometry.size.height/6)
                        }
                        HStack {
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "clock.arrow.circlepath", tabName: "Toggle")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .liked, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "list.dash", tabName: "Issues")
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

                            TabBarIcon(viewRouter: viewRouter, assignedPage: .records, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "chart.bar.xaxis", tabName: "Statistik")
                            TabBarIcon(viewRouter: viewRouter, assignedPage: .user, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.crop.circle", tabName: "Profil")
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
}


struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(viewRouter: ViewRouter())
            .preferredColorScheme(.light)
    }
}

struct PlusMenu: View {
    
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 50) {
            ZStack {
                Circle()
                    .foregroundColor(Color.main)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "record.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
            ZStack {
                Circle()
                    .foregroundColor(Color.main)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
        }
        .transition(.scale)
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: Page
    
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
            viewRouter.currentPage = assignedPage
        }
        .foregroundColor(viewRouter.currentPage == assignedPage ? Color.black : .white)
    }
}

