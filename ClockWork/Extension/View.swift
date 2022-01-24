//
//  Swift.swift
//  ClockWork
//
//  Created by Mattis on 27.12.21.


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
    //https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func textFieldAlert(isShowing: Binding<Bool>,
                            placeholder: String,
                        title: String, onAdd: @escaping (String) -> Void) -> some View {
        TextFieldAlert(onAdd: onAdd, isShowing: isShowing, placeholder: placeholder, presenting: { self }, title: title)
    }
    
    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-dismiss-the-keyboard-for-a-textfield
    func hideKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

