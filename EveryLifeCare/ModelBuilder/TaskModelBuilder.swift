//
//  TaskModelBuilder.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation

enum TaskModelBuilder {
    
    static func buildTaskListViewModel() -> TaskListViewModel {
        
        let dataStore = SQLDatabase.shared
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 20
        let session = URLSession(configuration: configuration)
        let httpClient = URLSessionHTTPClient(session: session)
        let taskAPI = TaskAPI(dataStore: dataStore, httpClient: httpClient)
        return TaskListViewModel(taskAPI: taskAPI)
    }
}

