//
//  TextFieldAlert.swift
//  ClockWork
//
//  Credit: https://stackoverflow.com/questions/56726663/how-to-add-a-textfield-to-alert-in-swiftui
//  Created by Mattis on 17.01.22.
//

import Foundation
import SwiftUI

struct TextFieldAlert<Presenting>: View where Presenting: View {
    
    let onAdd: (String) -> Void
    @Binding var isShowing: Bool
    var placeholder: String
    @State var input : String = ""
    let presenting: () -> Presenting
    let title: String

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting()
                    .blur(radius: self.isShowing ? 2 : 0)
                    .disabled(self.isShowing)
                VStack {
                    Text(self.title)
                    TextField(placeholder, text: $input)
                        .id(self.isShowing)
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Schließen")
                                .padding(3)
                            Spacer()
                        }.border(Color.blue, width: 1)
                        Button(action: {
                            if !input.isEmpty {
                                withAnimation {
                                    onAdd(input)
                                    self.isShowing.toggle()
                                }
                            }
                        }) {
                            Spacer()
                            Text("Bestätigen")
                                .padding(3)
                            
                        }.border(Color.blue, width: 1)
                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            } .onTapGesture {
                self.hideKeyboard()
            }
        }
    }

}
