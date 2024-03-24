//
//  SwiftLintFile.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

struct SwiftLintFile {}

extension SwiftLintFile: FileBuildable {
    func build() -> File {
        File(name: ".swiftlint.yml", content: Constants.swiftlint)
    }
}

extension SwiftLintFile: FileWritable {}
