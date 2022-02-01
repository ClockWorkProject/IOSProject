//
//  TextBinderManager.swift
//  ClockWork
//
//  Created by Mattis on 19.01.22.
// https://stackoverflow.com/questions/56476007/swiftui-textfield-max-length

import Foundation
import Combine

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int){
        characterLimit = limit
    }
}
