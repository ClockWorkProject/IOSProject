//
//  Published.swift
//  ClockWork
//
//  Created by Mattis on 19.01.22.
//
import SwiftUI

struct FullScreenProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .shadow(color: Color.main, radius: 10, x: 10, y: 10)
    }
}
