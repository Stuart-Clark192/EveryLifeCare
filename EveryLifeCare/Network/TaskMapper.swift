//
//  TaskMapper.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation

final class TaskMapper {

    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Task] {
        
        guard response.statusCode == OK_200, let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
            throw TaskAPI.Error.invalidData
        }
        return tasks
    }
}
