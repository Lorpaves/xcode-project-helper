//
//  main.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import ArgumentParser
import Foundation
import ShellOut

struct ProjectHelper: ParsableCommand {
    @Argument
    var project: String = ""

    @Option(name: [.customLong("path"), .short])
    var folder: String = FileManager.default.currentDirectoryPath

    @Option(name: [.customLong("summary"), .short])
    var summary: String?

    @Option(name: [.customLong("desc")])
    var description: String?

    @Option(name: [.customLong("homepage"), .short])
    var homepage: String?

    @Option(name: [.customLong("version"), .short])
    var version: String = "0.0.1"

    @Option(name: [.customLong("author"), .short])
    var author: String = NSFullUserName()

    @Option(name: [.customLong("email"), .short])
    var email: String = "986298194@qq.com"

    @Option(name: [.customLong("platforms")], parsing: .upToNextOption)
    var platformArgs: [Platform.Argument] = []

    @Option(name: [.customLong("dependecies"), .short])
    var dependecyArgs: [Pod.Argument] = []

    @Option(name: [.customLong("platform")])
    var platformArg: Platform.Argument = .init(arg: "ios13.0")

    func run() throws {
        let folder = URL(fileURLWithPath: folder)
        guard FileManager.default.fileExists(atPath: folder.path) else {
            Logger.error("Path not exits.")
            throw PHError.pathNotExits
        }
        do {
            try shellOut(to: "cd", at: folder.path)
            let builder = ProjectBuilder(folder: folder, project: project)
            Logger.info("Start creating .gitignore file…")
            try builder.writeGitIgnore()
            Logger.info("Start creating LICENSE file…")
            try builder.writeLicense(author: author)
            Logger.info("Start creating podspec file…")
            try builder.writePodspec(
                summary: summary,
                description: description,
                homepage: homepage,
                version: version,
                author: author,
                email: email,
                platformArgs: platformArgs,
                dependecyArgs: dependecyArgs
            )
            Logger.info("Start creating .swiftlint file…")
            let hasPodfile = !dependecyArgs.isEmpty
            try builder.writeSwitLint(hasPodfile: hasPodfile)
            if hasPodfile {
                Logger.info("Start creating Podfile…")
                try builder.writePodfile(platformArg: platformArg, podArgs: dependecyArgs)
                try shellOut(to: "pod install", arguments: ["--repo-update", "--verbose"], at: folder.path)
            } else {
                Logger.info("No pod was specified, skip creating Podfile.")
            }
            
        } catch {
            Logger.error(error.localizedDescription)
        }
    }
}

ProjectHelper.main()
