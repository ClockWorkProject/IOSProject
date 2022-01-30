//
//  IssueView.swift
//  ClockWork
//
//  Created by Mattis on 26.12.21.


import SwiftUI

struct IssueRootView: View {

    @ObservedObject var projectObserver : ProjectObserver
    
    var body: some View {
        VStack {
            //Ladescreen
            if !projectObserver.isLoaded {
                MiddleProgressView(color: Color.white)
            }
            // wenn es noch kein projekt in der Gruppe gibt
            else if projectObserver.projects.isEmpty {
                EmptyProjectView()
            }
            // normales IssueBoard
            else {
                IssueView(projectObserver: projectObserver)
            }
        }
    }
}




