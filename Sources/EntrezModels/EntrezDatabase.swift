//
//  File.swift
//  EntrezKit
//
//  Created by Ishihara Tsubasa on 14.11.26.
//

import Foundation

/// An Entrez database name (the `db=` parameter).
/// Common databases are provided as static members; any other can be created from a string literal.
public struct EntrezDatabase: RawRepresentable, Hashable, Sendable, ExpressibleByStringLiteral {
    public let rawValue: String

    public init(rawValue: String) { self.rawValue = rawValue }
    public init(stringLiteral value: String) { self.rawValue = value }

    public static let pubmed: Self = "pubmed"
    public static let pmc: Self = "pmc"
    public static let gene: Self = "gene"
    public static let protein: Self = "protein"
    public static let nucleotide: Self = "nuccore"
    public static let taxonomy: Self = "taxonomy"
    public static let mesh: Self = "mesh"
    public static let clinvar: Self = "clinvar"
}
