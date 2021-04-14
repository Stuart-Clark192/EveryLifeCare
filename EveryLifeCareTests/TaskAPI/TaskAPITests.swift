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

        let (task, task1Json) = TestTaskExamples.makeTask(id: 1, name: "Test", description: "Description", type: "medication")
        let data = TestTaskExamples.makeTasksData([task1Json])
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

    func test_fetchTasks_ReturnsNoUrl_whenInvalidURLGiven() throws {
        let url = ""
        let (sut, _) = makeSUT(url: url)

        let exp = expectation(description: "error returned")
        var receivedError: TaskAPI.Error?

        sut.fetchTasks() { completion in

            if case let .failure(error) = completion {
                receivedError = error
                exp.fulfill()
            } else {
                XCTFail("Expected Error, got \(completion)")
            }
        }

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError, TaskAPI.Error.noURL)
    }

    func test_fetchTasks_ReturnsInvalidData_whenInvalidDataIsReturned() throws {
        let (sut, client) = makeSUT()

        let exp = expectation(description: "error returned")
        var receivedError: TaskAPI.Error?

        sut.fetchTasks() { completion in

            if case let .failure(error) = completion {
                receivedError = error
                exp.fulfill()
            } else {
                XCTFail("Expected Error, got \(completion)")
            }
        }

        client.complete(withStatusCode: 200, data: anyData())

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedError, TaskAPI.Error.invalidData)
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
    
    private func anyData() -> Data {
        Data("any data".utf8)
    }
}
