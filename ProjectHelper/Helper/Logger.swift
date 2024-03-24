//
//  Logger.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation
import Rainbow

enum Logger {
    static func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        print(items.map { "\($0) " }.joined(separator: separator).lightRed.bold, separator: "", terminator: terminator)
    }

    static func info(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        print(items.map { "\($0) " }.joined(separator: separator), separator: "", terminator: terminator)
    }

    static func success(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        print(items.map { "\($0) " }.joined(separator: separator).lightGreen.bold, separator: "", terminator: terminator)
    }
}
