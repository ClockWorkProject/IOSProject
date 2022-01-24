//
//  ChangeIssueView.swift
//  ClockWork
//
//  Created by Mattis on 22.01.22.
//

import SwiftUI

struct ChangeIssueView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var issue: Issue
    
    var body: some View {
        
        NavigationView {
            List(IssuePages.allCases, id:\.self){ page in
                Button(action: {
                    FirebaseRepo.updateIssue(issue: issue, page: page, onSuccess: {
                        print("updated")
                        presentationMode.wrappedValue.dismiss()
                    }, onError: { errorMessage in
                        print(errorMessage)
                    })
                }) {
                    Text(page.text)
                        .foregroundColor(page.color)
                }
            }
            .navigationBarTitle("Issue verschieben", displayMode: .inline)
            .introspectNavigationController{ (UINavigatioController) in
                UINavigatioController.navigationBar.barTintColor = UIColor(named: "MainColor")
                UINavigatioController.navigationBar.tintColor = UIColor.white
                UINavigatioController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            }
        }
        
    }
    
}

