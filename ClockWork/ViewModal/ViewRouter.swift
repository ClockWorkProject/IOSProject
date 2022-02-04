//
//  ViewRouter.swift
//  CustomTabBar
//
// Created by BLCKBIRDS
// Visit BLCKBIRDS.COM FOR MORE TUTORIALS
import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: TabPage = .home
    
}


enum TabPage {
    case home
    case issueBoard
    case statistic
    case user
}
