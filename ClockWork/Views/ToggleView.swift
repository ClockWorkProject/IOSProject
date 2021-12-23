//
//  ToggleView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct ToggleView: View {
    var body: some View {
        ScrollView{
            CardView()
                .navigationBarTitle("Toggle", displayMode: .inline)
        }

    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView()
    }
}
