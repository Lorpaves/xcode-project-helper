//
//  Platform.swift
//  ProjectScript
//
//  Created by Lorpaves on 2024/3/23.
//

import ArgumentParser
import Foundation

struct Platform: Sendable {
    var version: String
    let representable: String
    private init(_ representable: String, version: String) {
        self.representable = representable
        self.version = version
    }

    static func macOS(version: String) -> Platform {
        Platform("osx", version: version)
    }

    static func iOS(version: String) -> Platform {
        Platform("ios", version: version)
    }

    static func watchOS(version: String) -> Platform {
        Platform("watchos", version: version)
    }

    static func tvOS(version: String) -> Platform {
        Platform("tvos", version: version)
    }

    func specRepresentable() -> String {
        "sepc.\(representable).deployment_target = \"\(version)\""
    }
    
    func podfileRepresentable() -> String {
        "platform :\(representable), '\(version)'"
    }

    struct Argument: ParsableArgument {
        typealias Output = Platform

        let arg: String
        var parser: PlatformParser.Type {
            PlatformParser.self
        }
    }
}

extension Collection where Iterator.Element == Platform.Argument {
    func toPlatforms() -> [Platform] {
        compactMap { $0.parse() }
    }
}
