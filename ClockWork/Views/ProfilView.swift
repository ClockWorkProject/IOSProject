//
//  IssueView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI
import Firebase

struct ProfilView: View {
    var body: some View {
        Button(action: {
            try? Auth.auth().signOut()
        },
               label: {
            Text("Ausloggen")
                
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
}

struct ProfilView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView()
    }
}
