//
//  TaskAPITests.swift
//  EveryLifeCareTests
//
//  Created by Stuart on 14/04/2021.
//

import XCTest
import Combine
@testable import EveryLifeCare

class SQLDatabaseStub: TaskDataStore {

    private let subject: PassthroughSubject<[Task], Never> = PassthroughSubject()
    
    func saveTasks(tasks: [Task]) throws {
        subject.send(tasks)
    }
    
    func dataObserver() -> AnyPublisher<[Task], Never> {
        subject.eraseToAnyPublisher()
    }
}

class TaskAPITests: XCTestCase {
    
    private var cancellableStore: Set<AnyCancellable> = []
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = "https://a-given-url.com"
        let (sut, client) = makeSUT(url: url)
        
        sut.fetchTasks() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [URL(string: url)!])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = "https://a-given-url.com"
        let (sut, client) = makeSUT(url: url)
        
        sut.fetchTasks() { _ in }
        sut.fetchTasks() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [URL(string: url)!, URL(string: url)!])
    }
    
    func test_fetchTasks_storesFetchedTasksToDatastore_AndReturnsTasks() throws {
        let url = "https://a-given-url.com"
        let (sut, client) = makeSUT(url: url)
        
        let (task, task1Json) = makeTask(id: 1, name: "Test", description: "Description", type: "medication")
        let data = makeTasksData([task1Json])
        let exp = expectation(description: "tasks returned")
        var receivedTask: Task?
        
        sut
            .dataObserver
            .sink { tasks in
                XCTAssertEqual(tasks.count, 1)
                receivedTask = tasks[0]
                exp.fulfill()
            }
            .store(in: &cancellableStore)
        
        sut.fetchTasks() { _ in }
        
        client.complete(withStatusCode: 200, data: data)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(task, receivedTask)
    }
    
    // MARK: Helpers
    private func makeSUT(url: String = "https://a-url.com",
                         file: StaticString = #file,
                         line: UInt = #line) -> (sut: TaskAPI, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let dataStore = SQLDatabaseStub()
        let sut = TaskAPI(dataStore: dataStore, httpClient: client, url: url)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (Result) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(withStatusCode code: Int, data: Data , at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }
    }
    
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
}
