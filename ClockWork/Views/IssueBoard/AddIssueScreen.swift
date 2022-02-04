//
//  DetailScreen.swift
//  ClockWork
//
//  Created by Mattis on 28.12.21.
//

import SwiftUI

struct AddIssueView: View {
    
    var issuePage: IssuePages
    var issueNumber : Int
    @Environment(\.presentationMode) var presentationMode
    // Damit man nicht zu viele Zeichen eingeben kann
    @ObservedObject var textBindingManager = TextBindingManager(limit: 100)
    @State var issueName = ""
    @State var issuDescription = ""
    let borderColor = Color.text.opacity(0.35)
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text("#\(issueNumber+1)")
                    .font(.footnote)
                    .padding([.leading], 8)
                Text("Issue")
                    .font(.footnote)
            }
            TextField("IssueTitel", text: $issueName)
                .disableAutocorrection(true)
                
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 24)
                .padding(8)
                .foregroundColor(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 1)
                )
                .background(Color.white)
                .padding([.bottom], 8)
                .padding([.top],8)
                .padding([.leading, .trailing], 8)
            Text("Beschreibung:")
                .font(.footnote)
                .padding([.leading, .trailing], 8)
            // Texteditor
            TextEditor(text: $textBindingManager.text)
                .foregroundColor(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 1)
                )
                .padding([.leading, .trailing], 8)
            
            Button(action: {
                if !issueName.isEmpty {
                    let issue = Issue(name: issueName, number: String(issueNumber+1), description: textBindingManager.text , issueState: issuePage)
                    FirebaseRepo.addIssue(issue: issue, onSuccess: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, onError: { errorMessage in
                        print(errorMessage)
                    })
                }
            },
                   label: {
                Text("Issue erstellen")
                    
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
                .navigationBarTitle("Issue erstellen", displayMode: .inline)
                .onTapGesture {
                    self.hideKeyboard()
                }
    }
}
