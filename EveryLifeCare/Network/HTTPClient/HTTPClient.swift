//
//  HTTPClient.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation

public typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
