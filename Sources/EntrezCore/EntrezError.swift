//
//  File.swift
//  EntrezKit
//
//  Created by Ishihara Tsubasa on 14.11.26.
//

import Foundation

public enum EntrezError: Error, Equatable, Sendable {
    /// The server responded with a non-2xx HTTP status.
    case httpStatus(Int)
    /// HTTP 429: rate limit exceeded (3 req/s without an API key, 10 req/s with one).
    case rateLimited
    /// The response body did not match the expected format.
    case decoding(String)
    /// An error message E-utilities returned with HTTP 200 (e.g. an invalid database name).
    case server(String)
}
