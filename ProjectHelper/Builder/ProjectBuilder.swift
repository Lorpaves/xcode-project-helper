//
//  ProjectBuilder.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation
import ShellOut

struct ProjectBuilder {
    var folder: URL
    var project: String
    func writePodspec(
        summary: String?,
        description: String?,
        homepage: String?,
        version: String,
        author: String,
        email: String,
        platformArgs: [Platform.Argument],
        dependecyArgs: [Pod.Argument]
    ) throws {
        let file = PodspecFile(
            project: project,
            summary: summary,
            description: description,
            homepage: homepage,
            version: version,
            author: author,
            email: email,
            platforms: platformArgs.compactMap { PlatformParser.parse($0) },
            dependecies: dependecyArgs.compactMap { PodParser.parse($0) }
        )
        try file.write(to: folder)
    }

    func writePodfile(
        platformArg: Platform.Argument,
        podArgs: [Pod.Argument]
    ) throws {
        if let platform: Platform = PlatformParser.parse(platformArg) {
            let podfile = PodFile(
                project: project,
                pods: podArgs.compactMap { PodParser.parse($0) },
                platform: platform
            )

            try podfile.write(to: folder)
        }
    }

    func writeSwitLint(hasPodfile: Bool) throws {
        try SwiftLintFile().write(to: folder)
        try runScript(hasPodfile: hasPodfile)
    }

    func writeLicense(author: String) throws {
        try LicenseFile(author: author).write(to: folder)
    }

    func writeGitIgnore() throws {
        try GitIgnoreFile().write(to: folder)
    }
}

extension ProjectBuilder {
    private func runScript(hasPodfile: Bool) throws {
        let url = try writeScript(to: folder, hasPodfile: hasPodfile)
        try shellOut(to: "ruby", arguments: ["'\(url.path)'"])
        try removeScript(at: url)
    }

    private func removeScript(at url: URL) throws {
        try FileManager.default.removeItem(at: url)
    }

    private func writeScript(to folder: URL, hasPodfile: Bool) throws -> URL {
        let script =
            """
            #!/usr/bin/env ruby

            require 'xcodeproj'

            # 指定Xcode项目文件路径
            project_path = '\(folder.appendingPathComponent("\(project).xcodeproj").path)'

            project = Xcodeproj::Project.open(project_path)

            group_path = '\(project)'
            group = project.main_group.find_subpath(group_path, true)
            file_paths = \(refrenceFiles(in: folder, hasPodfile: hasPodfile))
            file_paths.each do |path|
                file_reference = group.new_reference(path)
                # 注意：这里只是添加文件引用，并没有将文件添加到任何target的编译阶段
            end
            project.targets.each do |target|
              script_phase = target.new_shell_script_build_phase('Check SwiftLint')

              # 添加 Run Script Phase 到 target
              script_phase.shell_script = <<-SCRIPT
            if which swiftlint >/dev/null; then
              swiftlint
            else
              echo "warning: SwiftLint not installed."
            fi
            SCRIPT
              target.build_configurations.each do |config|
                config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
              end
            end

            # 保存项目文件
            project.save
            """
        let url = folder.appendingPathComponent("script.rb")
        try script.write(to: url, atomically: true, encoding: .utf8)
        return url
    }

    private func refrenceFiles(in folder: URL, hasPodfile: Bool) -> String {
        if hasPodfile {
            return "['\(folder.appendingPathComponent("\(project).podspec").path)', '\(folder.appendingPathComponent("Podfile").path)', '\(folder.appendingPathComponent(".swiftlint.yml").path)']"
        }
        return "['\(folder.appendingPathComponent("\(project).podspec").path)', '\(folder.appendingPathComponent(".swiftlint.yml").path)']"
    }
}
