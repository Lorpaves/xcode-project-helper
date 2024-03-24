//
//  PlatformParser.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

enum PlatformParser: Parsable {
    typealias Input = Platform.Argument

    typealias Output = Platform

    static var job: String {
        "platform"
    }

    static var pattern: String {
        #"([A-Za-z]+)\s*(\d+(\.\d+)*)*"#
    }

    static func handle(parsed result: NSTextCheckingResult?, of text: NSString) -> Platform? {
        guard let result, result.numberOfRanges > 1 else {
            return nil
        }
        let text = (text as String).lowercased() as NSString
        var platform: Platform
        let platformRepresentable = text.substring(with: result.range(at: 1))
        let hasVersion: Bool = result.numberOfRanges > 2
        switch platformRepresentable {
        case let ios where ios.hasPrefix("i"):
            platform = .iOS(version: "13.0")
        case let osx where osx.hasPrefix("m") || osx.hasPrefix("o"):
            platform = .macOS(version: "10.15")
        case let watchos where watchos.hasPrefix("w"):
            platform = .watchOS(version: "6.0")
        case let tvos where tvos.hasPrefix("t"):
            platform = .tvOS(version: "13.0")
        default:
            return nil
        }
        if hasVersion {
            let range = result.range(at: 2)
            if range.location != NSNotFound {
                var version = text.substring(with: range)
                if !version.contains(".") {
                    version.append(".0")
                }
                platform.version = version
            }
        }
        return platform
    }
}
