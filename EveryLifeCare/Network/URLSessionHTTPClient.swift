//
//  URLSessionHTTPClient.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    private struct UnexpectedValuesRepresentation: Error {}

    public func get(from url: URL, completion: @escaping (Result) -> Void) {

        // Use the following line to make sure we are actually capturing an invalid URL
        // let url = URL(string: "http://anotherURL.com")!
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data, response)))
            } else {
                completion(.failure(UnexpectedValuesRepresentation()))
            }
        }.resume()
    }
}

// The beuaty of the abstractions is that we can easily change this class to be an extension of URLSession rather than a full class
// And all we would need to do is to change the makeSUT factory method to use URLSession.shared and all our tests would still pass!
// Leaving it as a separate adapter class protects us from conflicts if Apple ever introduced a get fromURL method in the future

//extension URLSession: HTTPClient {
//
//    private struct UnexpectedValuesRepresentation: Error {}
//
//    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
//
//        // Use the following line to make sure we are actually capturing an invalid URL
//        // let url = URL(string: "http://anotherURL.com")!
//        dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let data = data, let response = response as? HTTPURLResponse {
//                completion(.success((data, response)))
//            } else {
//                completion(.failure(UnexpectedValuesRepresentation()))
//            }
//        }.resume()
//    }
//}

