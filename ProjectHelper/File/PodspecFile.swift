//
//  PodspecFile.swift
//  ProjectScript
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

struct PodspecFile {
    
    enum Key: String {
        case project
        case version
        case summary
        case description
        case homepage
        case author
        case email
        case platforms
        case dependecy
        case source
        
        func placeholder() -> String {
            "{" + rawValue.uppercased() + "}"
        }
    }

    var project = ""
    var summary: String?
    var description: String?
    var homepage: String?
    var version: String = "0.0.1"
    var author = NSFullUserName()
    var email = "986298194@qq.com"
    var platforms: [Platform] = []
    var dependecies: [Pod]?
}

extension PodspecFile {
    private func specHomepage() -> String {
        homepage ?? #"<#HOMEPAGE#>"#
    }

    private func specSummary() -> String {
        summary ?? #"<#SUMMARY#>"#
    }

    private func specDescription() -> String {
        description ?? #"<#DESCRIPTION#>"#
    }

    private func source() -> String {
        if let homepage {
            return "\(homepage).git"
        }
        return #"<#SOURCE#>"#
    }

    private func specDependecies() -> String {
        if let dependecies, !dependecies.isEmpty {
            return (0..<dependecies.count).map { index in
                if index > 0 {
                    return "  " + dependecies[index].asDependecy()
                }
                return dependecies[index].asDependecy()
            }.joined(separator: "\n")
        }
        return ""
    }

    private func specPlatforms() -> String {
        if platforms.isEmpty {
            return ""
        }
        return (0..<platforms.count).map { index in
            let rep = platforms[index].specRepresentable()
            if index > 0 {
                return "  " + rep
            }
            return rep
            
        }.joined(separator: "\n")
    }
}

extension PodspecFile {
    private func buildSpec() -> String {
        Constants.spec
            .replacingOccurrences(of: "\(PodspecFile.Key.project.placeholder())", with: project)
            .replacingOccurrences(of: "\(PodspecFile.Key.author.placeholder())", with: author)
            .replacingOccurrences(of: "\(PodspecFile.Key.email.placeholder())", with: email)
            .replacingOccurrences(of: "\(PodspecFile.Key.source.placeholder())", with: source())
            .replacingOccurrences(of: "\(PodspecFile.Key.dependecy.placeholder())", with: specDependecies())
            .replacingOccurrences(of: "\(PodspecFile.Key.platforms.placeholder())", with: specPlatforms())
            .replacingOccurrences(of: "\(PodspecFile.Key.version.placeholder())", with: version)
            .replacingOccurrences(of: "\(PodspecFile.Key.homepage.placeholder())", with: specHomepage())
            .replacingOccurrences(of: "\(PodspecFile.Key.summary.placeholder())", with: specSummary())
            .replacingOccurrences(of: "\(PodspecFile.Key.description.placeholder())", with: specDescription())
    }
    
}

extension PodspecFile: FileBuildable {
    func build() -> File {
        File(name: "\(project).podspec", content: buildSpec())
    }
}

extension PodspecFile: FileWritable {}
