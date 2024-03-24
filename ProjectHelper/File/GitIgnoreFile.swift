//
//  GitIgnoreFile.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/24.
//

import Foundation

struct GitIgnoreFile {}

extension GitIgnoreFile: FileBuildable {
    func build() -> File {
        File(name: ".gitignore", content: Constants.gitignore)
    }
}

extension GitIgnoreFile: FileWritable {}
