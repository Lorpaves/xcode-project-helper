//
//  Pod.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import ArgumentParser
import Foundation

struct Pod {
    let name: String
    let version: String?

    struct Argument: ExpressibleByArgument, ParsableArgument {
        typealias Output = Pod

        var parser: PodParser.Type {
            PodParser.self
        }

        var arg: String
    }
}

extension Pod {
    func asDependecy() -> String {
        if let version {
            return "spec.dependency '\(name)', '~> \(version)'"
        }
        return "spec.dependency '\(name)'"
    }
    func asPod() -> String {
        if let version {
            return "pod '\(name)', '~> \(version)'"
        }
        return "pod '\(name)'"
    }
}
