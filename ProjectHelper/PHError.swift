//
//  PHError.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

enum PHError: Error {
    case fileExits(_ file: String)
    case pathNotExits
}

extension PHError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .fileExits(let file):
                return "\(file) already exits, unable to create \(file)."
            case .pathNotExits:
                return "Path not exits, unable to set up the project."
        }
    }
}
