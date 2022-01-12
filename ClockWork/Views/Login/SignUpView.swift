//
//  SignUpView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct SignUpView: View {
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    
    let borderColor = Color.text.opacity(0.35)
    
    var body: some View {
        VStack {
            ZStack{
                Rectangle()
                    .fill(Color("MainColor"))
                    .ignoresSafeArea()
                VStack{
                    Image(uiImage: UIImage(named: "logo")!)
                    Text("ClockWork")
                        .font(Font.system(size: 34, weight: .bold))
                        .foregroundColor(Color.white)
                }
            }
        }
        TextField("Benutzername", text: $email)
            .disableAutocorrection(true)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 24)
            .padding(8)
            .foregroundColor(Color.text)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1)
            )
            .padding([.bottom], 8)
            .padding([.top],32)
            .padding([.leading, .trailing], 16)
        
        TextField("Email", text: $email)
            .disableAutocorrection(true)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 24)
            .padding(8)
            .foregroundColor(Color.text)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1)
            )
            .padding([.bottom], 8)
            .padding([.top],32)
            .padding([.leading, .trailing], 16)
        
        TextField("Passwort", text: $password)
            .disableAutocorrection(true)
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 24)
            .padding(8)
            .foregroundColor(Color.text)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(borderColor, lineWidth: 1)
            )
            .padding([.bottom], 8)
            .padding([.top],32)
            .padding([.leading, .trailing], 16)
        
        Spacer()
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
