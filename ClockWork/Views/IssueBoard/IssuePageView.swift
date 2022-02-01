//
//  IssueView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct IssuePageView: View {
    
    @State var page: IssuePages
    @ObservedObject var projectViewModal: ProjectObserver
    
    var body: some View {
        VStack{
            HStack {
                // Überschrift des States mit Zahl und Button zum hinzufügen
                Text(page.text)
                    .font(.system(size: 24))
                    .foregroundColor(page.color)
                Spacer()
                Text(String(projectViewModal.savedProject?.issues.filter({$0.issueState == page}).count ?? 0))
                    .font(.system(size: 24))
                Image(systemName: "square.on.square")
                NavigationLink(destination: AddIssueView(issuePage: page, issueNumber: projectViewModal.savedProject?.issues.count ?? 0 )){
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.black)
                }
            }
            .padding(10)
            ScrollView {
                ForEach(projectViewModal.savedProject?.issues.filter({$0.issueState == page}) ?? [], id: \.self){ issue in
                    IssueCard(issue: issue)
                }
            }
        }
        // Grauer Hintergrund mit abgerundeten Ecken
        .background(Color.backgroundgray)
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(page.color, lineWidth: 1)
                    
            )
            .padding(8)
            .navigationBarTitle("Issues", displayMode: .inline)
    }
}

//MARK: - IssueCard
struct IssueCard: View {
    
    var issue: Issue
    @State var showingSheet: Bool = false
    @State var showingDetailSheet: Bool = false
    
    // Card wie bei ToggleView
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(issue.name)
                        Spacer()
                    Text("#\(issue.number)")
                }
                .layoutPriority(100)
                Spacer()
            }
            .padding()
            .background(SwiftUI.Color.white)
        }
        .cornerRadius(10)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .onTapGesture ( perform: {showingDetailSheet = true} )
        .onLongPressGesture(perform: {showingSheet = true})
        .padding([.top], 2)
        .padding([.horizontal], 8)
        .sheet(isPresented: $showingDetailSheet){
            IssueDetailView(issue: issue)
        }
        .sheet(isPresented: $showingSheet) {
            IssueStateSheet(issue: issue)
        }
    }
    
}
