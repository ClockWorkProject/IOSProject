//
//  CardView.swift
//  ClockWork
//
//  Created by Mattis on 23.12.21.
//

import SwiftUI

struct CardView: View {
    
    // Collapse State
    @State var isCollapsed = true
    var toggledDate: ToggledDate
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    // unausgeklappte sicht mit Datum un Uhrzeit
                    HStack {
                        Text(toggledDate.dateString.replacingOccurrences(of: "-", with: "."))
                        Spacer()
                        Text(toggledDate.printPrettyTime())
                            .padding(5)
                        if isCollapsed {
                            Image(systemName: "chevron.down")
                                .foregroundColor(.black)
                        } else {
                            Image(systemName: "chevron.up")
                                .foregroundColor(.black)
                        }
                    }
                    
                }
                .layoutPriority(100)
                
                Spacer()
            }.padding()
                .contentShape(Rectangle())
                .onTapGesture {
                    isCollapsed.toggle()
                }
            // Wenn ausgeklappt zeige für jedes Issue in dem Datum die StundenZeit an
            if !isCollapsed {
                ForEach(toggledDate.toggledIssues, id: \.self) {toggledIssue in
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(toggledIssue.issueName)
                                    Text(toggledIssue.projectName)
                                        .font(.footnote)
                                } .padding(8)
                                Spacer()
                                Text(toggledIssue.printPrettyTime())
                                    .padding(5)
                            }
                            
                        }
                        .layoutPriority(100)
                        Spacer()
                    }.padding()
                }
            }
            
        }
        .background(SwiftUI.Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}
