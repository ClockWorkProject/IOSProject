//
//  SwiftUIView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct SwiftUIView: View {
    
    @State var email = ""
    @State var password = ""
    
    let borderColor = Color.text.opacity(0.35)

    var body: some View {
        
        VStack{
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
            .frame(width: .infinity, height: 200, alignment: .top)
            
            TextField("Email", text: $email)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity, alignment: .center)
                .frame(height: 24)
                .padding(8)
                .foregroundColor(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 1)
                )
                .padding([.bottom], 8)
                .padding([.top],32)
                .padding([.leading, .trailing], 16)
            TextField("Passwort", text: $password)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .frame(height: 24)
                .padding(8)
                .foregroundColor(Color.text)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 1)
                ).padding([.leading, .trailing], 16)
           
            Button(action: {
                
            }, label: {
                Text("Login")
                    
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                    .background(Color.main)
                    .clipShape(Capsule())
                    .padding([.leading, .trailing], 16)
                    .padding([.bottom], 8)
                    .padding([.top],32)
                    .font(Font.system(size: 21, weight: .semibold))
                    .foregroundColor(Color.white)
                    
                
            })
            VStack(spacing: 0){
                Text("Noch keinen Account?")
                    .font(Font.system(size: 13, weight: .regular))
                Button(action: {
                    
                }, label: {
                        Text("Registrieren")
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .center)
                    .background(Color.main)
                    .clipShape(Capsule())
                    .padding([.leading, .trailing], 16)
                    .font(Font.system(size: 21, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.white)
                })
                Spacer()
            }
            Spacer()
            
        }
        
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
