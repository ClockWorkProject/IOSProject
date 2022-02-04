//
//  Extension.swift
//  ClockWork
//
//  Created by Mattis on 22.01.22.
// https://stackoverflow.com/a/43434964

import Foundation


extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
