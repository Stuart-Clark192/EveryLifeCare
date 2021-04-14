//
//  SQLDatabaseTests.swift
//  EveryLifeCareTests
//
//  Created by Stuart on 14/04/2021.
//

import XCTest
import Combine
@testable import EveryLifeCare

class SQLDatabaseTests: XCTestCase {

    private var cancellableStore: Set<AnyCancellable> = []
    
    override func tearDown() {
        cancellableStore.removeAll()
    }
    
    func test_init_returnsDatabase() {
        let sut = makeSUT()
        XCTAssertNotNil(sut)
    }

//    func test_savingTasks_publishesTaskList() throws {
//
//        let sut = makeSUT()
//        let expectedTasks = anyTasks()
//        var receivedTasks: [Task]?
//
//        let exp = expectation(description: "Expect tasks")
//
//        try sut.saveTasks(tasks: anyTasks())
//
//        sut.dataObserver()
//            .sink { _ in
//                XCTFail("Publisher should not complete")
//            } receiveValue: { tasks in
//                receivedTasks = tasks
//                print("****Tasks got!!!!! \(tasks)")
//                exp.fulfill()
//            }
//            .store(in: &cancellableStore)
//        
//        wait(for: [exp], timeout: 1.0)
//
//    }
    
    // MARK: Helpers
    private func makeSUT() -> SQLDatabase {
        
        let sut = SQLDatabase.shared
        sut.resetDatabase()
        return sut
    }
    
    private func anyTasks() -> [Task] {
        [Task(id: 1, name: "Test task 1", description: "The first test task", type: "hydration"),
         Task(id: 2, name: "Test task 2", description: "The second test task", type: "medication")]
    }
}
