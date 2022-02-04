//
//  IssueView.swift
//  ClockWork
//
//  Created by Mattis on 30.01.22.
//

import SwiftUI

struct IssueView: View {
    
    @ObservedObject var projectObserver : ProjectObserver
    @State private var selectedSport = 0
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                // Form Picker nur ohne Form
                NavigationLink(destination: PickView(projectObserver: projectObserver)) {
                    HStack {
                        Text("Projekt:")
                            .foregroundColor(Color.black)
                        Spacer()
                        Text(projectObserver.savedProject?.name ?? "Pick One ?")
                            .foregroundColor(Color.gray)
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.gray)
                            .padding(.trailing)
                    }
                    .padding([.leading, .trailing], 16)
                    .padding([.bottom], 8)
                    .padding([.top],8)
                    .background(Color.backgroundgray)
                    .clipShape(Capsule())
                }
                Spacer()
            }
            // PageView für jeden IssueState
            TabView {
                ForEach(IssuePages.allCases, id: \.self) { issuepage in
                    IssuePageView(page: issuepage, projectViewModal: projectObserver)
                    
                }
            }
            .tabViewStyle(PageTabViewStyle())
            // Introspect um die Farbe der Punkte zu ändern, normal sind die Punkte zu hell und nicht sichtbar
            .introspectPageControl{ (UIPageControl) in
                UIPageControl.currentPageIndicatorTintColor = .black
                UIPageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
            }
        }
    }
}
