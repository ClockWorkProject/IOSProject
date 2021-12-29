//
//  DetailScreen.swift
//  ClockWork
//
//  Created by Mattis on 28.12.21.
//

import SwiftUI

struct DetailScreen: View {
    var body: some View {
        VStack{
            HStack {
                Text("Titel")
                    .font(.system(size: 24))
                Spacer()
                Text("3")
                    .font(.system(size: 24))
                Image(systemName: "square.on.square")
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.black)
                })
            }
            Spacer()
        }
            .padding(10)
            .background(Color( "LightGrey"))
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        
                )
                .padding(8)
                .navigationBarTitle("Details", displayMode: .inline)

    }
}

struct DetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        DetailScreen()
    }
}
