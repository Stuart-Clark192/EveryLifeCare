//
//  TaskLoader.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation
import Combine

protocol TaskLoader {
    typealias Result = Swift.Result<[Task], Error>
    
    var dataObserver: AnyPublisher<[Task], Never> { get }
    
    func fetchTasks(completion: @escaping (Subscribers.Completion<TaskAPI.Error>) -> Void)
}
