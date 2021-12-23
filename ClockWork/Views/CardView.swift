//
//  CardView.swift
//  ClockWork
//
//  Created by Mattis on 23.12.21.
//

import SwiftUI

struct CardView: View {
    
    @State var isCollapsed = true
    
    var body: some View {
        VStack {
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Heute")
                        Spacer()
                        Text("3std 22min")
                            .padding(5)
                        Button(action: {
                            isCollapsed.toggle()
                        }, label: {
                            if isCollapsed {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.black)
                            } else {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(.black)
                            }
                        })
                            
                    }
                    
                }
                .layoutPriority(100)
                
                Spacer()
            }
            .padding()
            .background(SwiftUI.Color.white)
        }
       
        .cornerRadius(10)
        .shadow(radius: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
