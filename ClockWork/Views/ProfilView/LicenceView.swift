//
//  LicenceView.swift
//  ClockWork
//
//  Created by Mattis on 02.02.22.
//

import SwiftUI
import AcknowList

struct LicenceView: View {
    var body: some View {
        AcknowListSwiftUIView(plistPath:  Bundle.main.path(forResource: "License", ofType: "plist")!)
    }
}

struct LicenceView_Previews: PreviewProvider {
    static var previews: some View {
        LicenceView()
    }
}
