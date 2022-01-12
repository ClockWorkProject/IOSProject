//
//  Swift.swift
//  ClockWork
//
//  Created by Mattis on 27.12.21.
//https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui

import Foundation
import Introspect
import SwiftUI

extension View {
    public func introspectPageControl(customize: @escaping (UIPageControl) -> ()) -> some View {
        return inject(UIKitIntrospectionView(
            selector: { introspectionView in
                guard let viewHost = Introspect.findViewHost(from: introspectionView) else {
                    return nil
                }
                return Introspect.previousSibling(containing: UIPageControl.self, from: viewHost)
            },
            customize: customize
        ))
    }
    
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

