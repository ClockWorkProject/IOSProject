//
//  ChangeView.swift
//  ClockWork
//
//  Created by Mattis on 21.12.21.
//

import SwiftUI

struct ChangeView: View {
    @State var isLogedIn = false
    @StateObject var viewRouter = ViewRouter()
    
    var body: some View {
        if !isLogedIn {
            LoginView(isLogedIn: $isLogedIn)
        } else {
            CustomTabView(viewRouter: viewRouter)
        }
    }
}

struct ChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeView()
    }
}
