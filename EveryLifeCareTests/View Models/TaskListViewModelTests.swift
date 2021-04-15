//
//  TaskListViewModelTests.swift
//  EveryLifeCareTests
//
//  Created by Stuart on 14/04/2021.
//

import XCTest
import Combine
@testable import EveryLifeCare

class TaskListViewModelTests: XCTestCase {

    private var cancellableStore: Set<AnyCancellable> = []
    
    func test_fectchingTasks_WithHTTP200StatusCode_EmitsTasks() {

        let (sut, client, testQueue) = makeSUT()
        let (task, task1Json) = TestTaskExamples.makeTask(id: 1, name: "Test", description: "Description", type: "medication")
        let data = TestTaskExamples.makeTasksData([task1Json])
        let exp = expectation(description: "tasks returned")
        var receivedTasks: [Task] = []
        sut.fetchTasks()
        client.complete(withStatusCode: 200, data: data)

        sut
            .taskList
            .publisher
            .collect()
            .sink { tasks in
                receivedTasks = tasks
                testQueue.sync {}
                exp.fulfill()
            }
            .store(in: &cancellableStore)


        wait(for: [exp], timeout: 1.0)

        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(receivedTasks, [task])
    }

    func test_fectchingTasks_WithErrorCode_EmitsError() {

        let (sut, client, testQueue) = makeSUT()
        let exp = expectation(description: "error set")
        sut.fetchTasks()

        client.complete(with: anyNSError())

        sut
            .taskList
            .publisher
            .collect()
            .sink { _ in
                testQueue.sync {}
                exp.fulfill()
            }
            .store(in: &cancellableStore)

        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(sut.isError)
    }

    func test_updateFilters_setsCorrectlyFilteredTasks() {
        let (sut, client, testQueue) = makeSUT()
        let (_, task1Json) = TestTaskExamples.makeTask(id: 1, name: "Test", description: "Description", type: "medication")
        let (hydrationTask, task2Json) = TestTaskExamples.makeTask(id: 2, name: "Test2", description: "Description2", type: "hydration")
        let data = TestTaskExamples.makeTasksData([task1Json, task2Json])
        let exp = expectation(description: "tasks returned")
        var receivedTasks: [Task] = []
        sut.fetchTasks()
        client.complete(withStatusCode: 200, data: data)

        sut.updateFilters(filtersSelected: ["hydration"])
        sut
            .taskList
            .publisher
            .collect()
            .sink { tasks in
                receivedTasks = tasks
                testQueue.sync {}
                exp.fulfill()
            }
            .store(in: &cancellableStore)


        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(receivedTasks, [hydrationTask])

    }
    
    // MARK: Helpers
    private func makeSUT(url: String = "https://a-url.com",
                         file: StaticString = #file,
                         line: UInt = #line) -> (sut: TaskListViewModel, client: HTTPClientSpy, testQueue: DispatchQueue) {
        let client = HTTPClientSpy()
        let dataStore = SQLDatabaseStub()
        let taskAPI = TaskAPI(dataStore: dataStore, httpClient: client, url: url)
        let testQueue = DispatchQueue(label: "Testing UI Queue")
        
        let sut = TaskListViewModel(taskAPI: taskAPI, uiQueue: testQueue)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return (sut, client, testQueue)
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
}
