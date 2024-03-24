//
//  Parsable.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation

protocol Parsable {
    associatedtype Input: ParsableArgument
    associatedtype Output
    static var job: String { get }
    static var pattern: String { get }
    static func handle(parsed result: NSTextCheckingResult?, of text: NSString) -> Output?
}

extension Parsable {
    static func parse(_ argument: Input) -> Output? {
        let text = argument.arg
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = text as NSString
            let result = regex.firstMatch(in: text, range: NSRange(location: 0, length: nsString.length))
            return handle(parsed: result, of: nsString)
        } catch {
            #if DEBUG
            Logger.error("Error while parsing \(job.lightYellow.bold) from \(text). \(error.localizedDescription)")
            #endif
            return nil
        }
    }

    static func parse(_ argument: Input) -> [Output] {
        let text = argument.arg
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = text as NSString

            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.compactMap { result -> Output? in
                if let output = handle(parsed: result, of: nsString) {
                    return output
                }
                Logger.error("Failed to parsing \(job.lightYellow.bold) from argument \(nsString.substring(with: result.range(at: 0)))")
                Logger.error(nsString.substring(with: result.range(at: 1)) + " was not recognized as \(job).")
                return nil
            }
        } catch {
            #if DEBUG
                Logger.error("Error while parsing \(job.lightYellow.bold) from \(text). \(error.localizedDescription)")
            #endif
        }
        return []
    }
}
