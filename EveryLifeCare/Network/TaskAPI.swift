//
//  TaskAPI.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation
import Combine

public class TaskAPI: TaskLoader {
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case noURL
        case databaseStore
    }
    
    private let tasksURL: String
    private let httpClient: HTTPClient
    private var cancellableStore: Set<AnyCancellable>
    
    var dataStore: TaskDataStore
    
    var dataObserver: AnyPublisher<[Task], Never> {
        dataStore.dataObserver()
    }
    
    public init(dataStore: TaskDataStore, httpClient: HTTPClient, url: String = "https://adam-deleteme.s3.amazonaws.com/tasks.json") {
        self.dataStore = dataStore
        self.httpClient = httpClient
        self.tasksURL = url
        cancellableStore = []
    }
    
    // So we want 2 things to happen on calling fetch tasks
    // 1. We want to watch for the URL Call completing or failing so that we can show the user a loading spinner and any error
    // 2. if the call has succeded write the results to the database
    
    func fetchTasks(completion: @escaping (Subscribers.Completion<TaskAPI.Error>) -> Void) {
        
        guard let url = URL(string: tasksURL) else {
            completion(.failure(.noURL))
            return
        }
        
        httpClient.get(from: url) { [weak self] response in
            
            switch response {
            case let .success((data, response)):
                guard let tasks = try? TaskMapper.map(data, from: response) else {
                    completion(.failure(.invalidData))
                    return
                }
                do {
                    try self?.dataStore.saveTasks(tasks: tasks)
                } catch {
                    completion(.failure(.databaseStore))
                    return
                }
                
                completion(.finished)
                
            case .failure(_):
                completion(.failure(.connectivity))
            }
        }
    }
}
