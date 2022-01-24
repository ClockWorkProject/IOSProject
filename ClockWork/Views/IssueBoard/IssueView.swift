//
//  IssueView.swift
//  ClockWork
//
//  Created by Mattis on 26.12.21.
//https://stackoverflow.com/questions/57480588/how-can-i-change-the-pickerstyle-in-swiftui-like-embed-in-form-but-static-and-n

import SwiftUI

struct IssueView: View {
    @ObservedObject var projectObserver = ProjectObserver.shared
    @State private var selectedSport = 0
    @State var picked = ""
    
    @State private var issueHandler: (UInt, UInt) = (0,0)
    
    var body: some View {
        VStack {
            if !projectObserver.isLoaded {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
            else if projectObserver.projects.isEmpty {
                EmptyProjectView()
            }
            else {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: PickView(picked: $picked)) {
                            HStack {
                                Text("Projekt:")
                                    .foregroundColor(Color.black)
                                Spacer()
                                Text(projectObserver.savedProject?.name ?? "Pick One ?")
                                    .foregroundColor(Color.gray)
                                Image(systemName: "chevron.right")  .foregroundColor(Color.gray)
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
                    TabView {
                        ForEach(IssuePages.allCases, id: \.self) { issuepage in
                            IssueCardView(page: issuepage)
                            
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .introspectPageControl{ (UIPageControl) in
                        UIPageControl.currentPageIndicatorTintColor = .black
                        UIPageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
                    }
                }.onAppear(perform: listenIssue)
                    .onDisappear(perform: unlistenIssue)
            }
        } .onAppear(perform: listenProject)
    }
    private func listenProject() {
        projectObserver.projectListener()
    }
    private  func listenIssue() {
        issueHandler = projectObserver.observeIssues()
    }
    private func unlistenIssue() {
        projectObserver.unlistenIssue(handle: issueHandler)
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView()
    }
}



