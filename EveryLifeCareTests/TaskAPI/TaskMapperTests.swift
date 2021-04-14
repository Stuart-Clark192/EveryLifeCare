//
//  TaskMapperTests.swift
//  EveryLifeCareTests
//
//  Created by Stuart on 14/04/2021.
//

import XCTest
@testable import EveryLifeCare

class TaskMapperTests: XCTestCase {
    
    func test_mapperReturnsValidData_For200Response() {
        
        let response = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
        let (task, task1Json) = makeTask(id: 1, name: "Test", description: "Description", type: "medication")
        let data = makeTasksData([task1Json])
        
        let decodedTasks = try? TaskMapper.map(data, from: response)
        guard let tasks = decodedTasks else {
            XCTFail("Expected to decode 1 task")
            return
        }
        XCTAssertEqual(task, tasks[0])
    }
    
    func test_mapperReturnsInvalidData_For200ResponseWithInvalidData() {
        
        let response = HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
        let data = anyData()
        
        do {
            _ = try TaskMapper.map(data, from: response)
        } catch {
            XCTAssertEqual(error as! TaskAPI.Error, TaskAPI.Error.invalidData)
        }
    }

    
    // MARK: Helpers
    private func makeTask(id: Int,
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
    
    private func makeTasksData(_ tasks: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: tasks)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    private func anyData() -> Data {
        Data("any data".utf8)
    }

}
