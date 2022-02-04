//
//  MiddleProgressView.swift
//  ClockWork
//
//  Created by Mattis on 30.01.22.
//

import SwiftUI

struct MiddleProgressView: View {
    
    @State var color: Color
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
        ProgressView()
            .progressViewStyle(FullScreenProgressViewStyle())
                Spacer()
            }
            Spacer()
        }.background(color)
            .ignoresSafeArea()
    }
}


