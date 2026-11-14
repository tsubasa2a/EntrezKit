//
//  File.swift
//  EntrezKit
//
//  Created by Ishihara Tsubasa on 15.11.26.
//

import EntrezModels
import Foundation

/// A general-purpose client for NCBI E-utilities, independent of any specific database.
public struct EntrezClient: Sendable {
    public struct Configuration: Sendable {
        /// Optional NCBI API key. Raises the rate limit from 3 to 10 requests per second.
        public var apiKey: String?
        /// Tool name and contact email, as recommended by NCBI.
        public var tool: String?
        public var email: String?
        public var baseURL: URL

        public init(
            apiKey: String? = nil,
            tool: String? = nil,
            email: String? = nil,
            baseURL: URL = URL(string: "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/")!
        ) {
            self.apiKey = apiKey
            self.tool = tool
            self.email = email
            self.baseURL = baseURL
        }
    }

    private let configuration: Configuration
    private let http: any HTTPClient

    public init(configuration: Configuration = .init(), http: any HTTPClient = URLSession.shared) {
        self.configuration = configuration
        self.http = http
    }


    // MARK: - Internal

    func makeRequest(_ endpoint: String, db: EntrezDatabase, _ items: [URLQueryItem]) -> URLRequest {
        var components = URLComponents(
            url: configuration.baseURL.appendingPathComponent(endpoint),
            resolvingAgainstBaseURL: false
        )!
        var query = [URLQueryItem(name: "db", value: db.rawValue)] + items
        if let apiKey = configuration.apiKey { query.append(.init(name: "api_key", value: apiKey)) }
        if let tool = configuration.tool { query.append(.init(name: "tool", value: tool)) }
        if let email = configuration.email { query.append(.init(name: "email", value: email)) }
        components.queryItems = query
        return URLRequest(url: components.url!)
    }

    private func get(_ endpoint: String, db: EntrezDatabase, _ items: [URLQueryItem]) async throws -> Data {
        let (data, response) = try await http.send(makeRequest(endpoint, db: db, items))
        if let http = response as? HTTPURLResponse {
            if http.statusCode == 429 { throw EntrezError.rateLimited }
            guard (200..<300).contains(http.statusCode) else { throw EntrezError.httpStatus(http.statusCode) }
        }
        return data
    }

    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw EntrezError.decoding(String(describing: error))
        }
    }
}
