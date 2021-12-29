//
//  IssueView.swift
//  ClockWork
//
//  Created by Mattis on 26.12.21.
//

import SwiftUI

struct IssueView: View {
    var body: some View {
            TabView {
                ForEach(IssuePages.allCases, id: \.self) { issuepage in
                    IssueCardView(page: issuepage)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .introspectPageControl{ (UIPageControl) in
                UIPageControl.currentPageIndicatorTintColor = .black
                UIPageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
            }
    }
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        IssueView()
    }
}

enum IssuePages: CaseIterable{
    
    case open, todo, doing, review, blocker, closed
    
    var text: String {
        switch self {
        case .open:
            return "Open"
        case .todo:
            return "Todo"
        case .doing:
            return "Doing"
        case .review:
            return "Review"
        case .blocker:
            return "Blocker"
        case .closed:
            return "Closed"
        }
    }
    
    var color: Color{
        switch self {
        case .open:
            return Color.black
        case .todo:
            return Color.green
        case .doing:
            return Color.blue
        case .review:
            return Color.review
        case .blocker:
            return Color.red
        case .closed:
            return Color.black
        }
    }
}
