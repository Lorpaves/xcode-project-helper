//
//  FileWritable.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation
import ShellOut

protocol FileWritable {
    func write(to directory: URL) throws
}

extension FileWritable where Self: FileBuildable {
    func write(to directory: URL) throws {
        let file = build()
        var isDirectory: ObjCBool = .init(false)
        let dest = directory.appendingPathComponent(file.name)
        if FileManager.default.fileExists(atPath: dest.path, isDirectory: &isDirectory) && !isDirectory.boolValue {
            throw PHError.fileExits(file.name)
        }
        try file.content.write(to: dest, atomically: true, encoding: .utf8)
        Logger.success("Created \(file.name) at \(dest.path)")
    }
}
