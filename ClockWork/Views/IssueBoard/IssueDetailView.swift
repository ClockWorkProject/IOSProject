//
//  SwiftUIView.swift
//  ClockWork
//
//  Created by Mattis on 01.02.22.
//

import SwiftUI

struct IssueDetailView: View {
    

    @Environment(\.presentationMode) var presentationMode
    var issue: Issue
    let borderColor = Color.text.opacity(0.35)
    
    var body: some View {
        NavigationView {
        VStack(alignment: .leading){
            HStack {
                Text("#\(issue.number)")
                    .font(.footnote)
                    .padding([.leading], 8)
                Text("Issue")
                    .font(.footnote)
            }
            Text("\(issue.name)")
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 24)
                .padding(8)
                .foregroundColor(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 1)
                )
                .padding([.bottom], 8)
                .padding([.top],8)
                .padding([.leading, .trailing], 8)
            Text("Beschreibung:")
                .font(.footnote)
                .padding([.leading, .trailing], 8)
            // Texteditor
            Text("\(issue.description ?? "")")
                .foregroundColor(Color.black)
                .padding(8)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .overlay(
                    RoundedRectangle(cornerRadius: 5 )
                        .stroke(borderColor, lineWidth: 1)
                )
                
            
            Button(action: {
               
            },
                   label: {
                Text("Issue bearbeiten")
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                    .background(Color.main)
                    .clipShape(Capsule())
                    .padding([.leading, .trailing], 16)
                    .padding([.bottom], 8)
                    .padding([.top],32)
                    .font(Font.system(size: 21, weight: .semibold))
                    .foregroundColor(Color.white)
                    
                
            })
        }
        // gleiches Overlay wie bei den Issuepage
        .padding(10)
                   .background(Color( "LightGrey"))
                   .overlay(
                           RoundedRectangle(cornerRadius: 10)
                               .stroke(Color.gray, lineWidth: 1)
                               
                       )
                       .padding(8)
                       .navigationBarTitle("Issue", displayMode: .inline)
                       .introspectNavigationController{ (UINavigatioController) in
                           UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
                           UINavigatioController.navigationBar.tintColor = UIColor.white
                           UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                       }
        }
        
  
    }
}
