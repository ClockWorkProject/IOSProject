//
//  Swift.swift
//  ClockWork
//
//  Created by Mattis on 27.12.21.
//

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
}
