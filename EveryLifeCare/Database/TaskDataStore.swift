//
//  TaskDataStore.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation
import Combine

public protocol TaskDataStore {
    
    func saveTasks(tasks: [Task]) throws
    
    func dataObserver() -> AnyPublisher<[Task], Never>
}
