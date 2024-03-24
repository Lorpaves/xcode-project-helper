//
//  LicenseFile.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

struct LicenseFile: FileBuildable {
    var author = NSFullUserName()

    func build() -> File {
        File(name: "LICENSE", content: Constants.license(name: author))
    }
}

extension LicenseFile: FileWritable {}
