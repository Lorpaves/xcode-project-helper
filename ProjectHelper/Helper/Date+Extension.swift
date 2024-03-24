//
//  Date+Extension.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

extension Date {
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    static var currentYear: Int {
        Calendar.current.component(.year, from: Date())
    }
    
    func formatted(_ style: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style
        return formatter.string(from: self)
    }
}
