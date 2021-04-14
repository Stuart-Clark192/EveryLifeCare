//
//  TestTaskExamples.swift
//  EveryLifeCareTests
//
//  Created by Stuart on 14/04/2021.
//

import Foundation
@testable import EveryLifeCare

enum TestTaskExamples {
    
    static func makeTask(id: Int,
                          name: String,
                          description: String,
                          type: String) -> (model: Task, json: [String: Any]) {
        
        let task = Task(id: id, name: name, description: description, type: type)
        
        // Swift 5
        let jsonTasks = [
            "id": task.id,
            "name": task.name,
            "description": task.description,
            "type": task.type
        ].compactMapValues { $0 }
        
        return (task, jsonTasks)
    }
    
    static func makeTasksData(_ tasks: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: tasks)
    }
}
