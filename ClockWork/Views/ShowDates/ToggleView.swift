//
//  ToggleView.swift
//  ClockWork
//
//  Created by Mattis on 20.12.21.
//

import SwiftUI

struct ToggleView: View {
    
    @ObservedObject var dateObserver = DateObserver.shared
    
    var body: some View {
        ScrollView{
            ForEach(dateObserver.toggledDates, id: \.self) {toggledDate in
                CardView(toggledDate: toggledDate)
            }
        }
        .navigationBarTitle("Toggle", displayMode: .inline)

    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleView()
    }
}
