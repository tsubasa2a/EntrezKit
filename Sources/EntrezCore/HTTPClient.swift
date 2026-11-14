//
//  File.swift
//  EntrezKit
//
//  Created by Ishihara Tsubasa on 14.11.26.
//

import Foundation

/// Abstraction over the transport layer, so tests and previews can inject a mock.
public protocol HTTPClient: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {
    public func send(_ request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}
