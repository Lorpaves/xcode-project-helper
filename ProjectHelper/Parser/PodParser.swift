//
//  PodParser.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

enum PodParser: Parsable {
    typealias Input = Pod.Argument

    typealias Output = Pod

    static var job: String {
        "pod"
    }

    static var pattern: String {
        #"([A-Za-z]+)\s*(\d+(\.\d+)*)*"#
    }

    static func handle(parsed result: NSTextCheckingResult?, of text: NSString) -> Pod? {
        guard let result, result.numberOfRanges > 1 else {
            return nil
        }
        let range = result.range(at: 1)
        let podName: String
        if range.location != NSNotFound {
            podName = text.substring(with: result.range(at: 1))
        } else {
            podName = text as String
        }
        if result.numberOfRanges > 2 {
            let range = result.range(at: 2)
            let version: String? = {
                if range.location == NSNotFound {
                    return nil
                }
                return text.substring(with: range)
            }()
            return Pod(
                name: podName,
                version: version
            )
        }
        return Pod(
            name: podName,
            version: nil
        )
    }
}
