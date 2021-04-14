//
//  Task.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

public struct Task: Codable, Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let description: String
    public let type: String
}

