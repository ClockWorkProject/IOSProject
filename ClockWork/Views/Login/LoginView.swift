//
//  SwiftUIView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    @State var errorString: String?
    
    let borderColor = Color.text.opacity(0.35)

    var body: some View {
        
        VStack{
            // Lila Rechteck mit Bild
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
            .frame(height: 200)
            .frame(maxWidth: .infinity, alignment: .top)
            
            // EmailFeld
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
            // PasswortFelt
            SecureField("Passwort", text: $password)
                .disableAutocorrection(true)
                .frame(maxWidth: .infinity)
                .frame(height: 24)
                .padding(8)
                .foregroundColor(Color.text)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(borderColor, lineWidth: 1)
                ).padding([.leading, .trailing], 16)
           //Login Button
            Button(action: {
                if self.email != "" && self.password != ""{
                    // Wenn passwort und email eingegeben wurde versuche dich einzuloggen
                    LoginController.logIn(email: email, password: password, onSuccess: {
                        print("Sign In!")
                    }, onError: { (error) in
                        errorString = error
                    })
                }
                else {
                    errorString = "Bitte geben sie ein Passwort und eine Email-Adresse ein"
                }
            },
                   label: {
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
            //RegestrierenButton mit Überschrift
            VStack(spacing: 0){
                Text("Noch keinen Account?")
                    .font(Font.system(size: 13, weight: .regular))
                
                Button(action: {
                    // Wenn passwort und email eingegeben wurde versuche dich zu regestrieren
                    if self.email != "" && self.password != ""{
                        LoginController.signUpUser(email: email, password: password, onSuccess: {
                            print("Sign In!")
                        }, onError: { (error) in
                            errorString = error
                            
                        })
                    } else {
                        errorString = "Bitte geben sie ein Passwort und eine Email adresse ein"
                    }
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
        // Alert für Error
        .alert(item: $errorString, content: {errorMessage in Alert(
            title: Text("Fehler"),
            message: Text(errorMessage),
            dismissButton: .default(Text("Okay"), action: {
                
            })
        )})
    }
}
