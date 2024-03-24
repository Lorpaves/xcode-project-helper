//
//  PodFile.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

struct PodFile {
    var project = ""
    var pods: [Pod] = []
    var platform: Platform = .iOS(version: "13.0")
    
    func buildPodfile() -> String {
        """
source 'https://gitee.com/llby1/private-pods.git'
source 'https://cdn.cocoapods.org/'

\(platform.podfileRepresentable())

target '\(project)' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  \(podsRepresentable())
end
"""
    }
    private func podsRepresentable() -> String {
        (0..<pods.count).map { index in
            if index > 0 {
                return "  " + pods[index].asPod()
            }
            return pods[index].asPod()
        }.joined(separator: "\n")
    }
}

extension PodFile: FileBuildable {
    func build() -> File {
        return File(name: "Podfile", content: buildPodfile())
    }
}

extension PodFile: FileWritable {}
