//
//  ParsableArgument.swift
//  ProjectHelper
//
//  Created by Lorpaves on 2024/3/23.
//

import Foundation
import ArgumentParser

protocol ParsableArgument: ExpressibleByArgument {
    associatedtype Output
    associatedtype Parser: Parsable
    var arg: String { get }
    var parser: Parser.Type { get }
    func parse() -> Output?
    init(arg: String)
}

extension ParsableArgument where Parser.Input == Self, Parser.Output == Self.Output {
    func parse() -> Output? {
        parser.parse(self)
    }
}

extension Collection where Iterator.Element: ParsableArgument {
    func parse() -> [Element.Output] {
        compactMap { $0.parse() }
    }
}

extension ParsableArgument {
    init?(argument: String) {
        self.init(arg: argument)
    }
}
