//
//  TaskListViewModel.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    
    @Published public var taskList: [Task] = []
    @Published public var isError = false
    @Published public var isLoading = false
    
    public var cancellableStore: Set<AnyCancellable>
    
    private let taskAPI: TaskLoader
    private var filtersSelected: Set<String> = []
    
    private var allTasks: [Task] = []
    private let uiQueue: DispatchQueue
    
    public init(taskAPI: TaskLoader, uiQueue: DispatchQueue = DispatchQueue.main) {
        self.taskAPI = taskAPI
        self.uiQueue = uiQueue
        cancellableStore = []
        
        taskAPI
            .dataObserver
            .sink { [weak self] tasks in
                self?.allTasks = tasks
                self?.applyFilter()
            }
            .store(in: &cancellableStore)
    }
    
    func fetchTasks() {
        
        isLoading = true
        taskAPI
            .fetchTasks { [weak self] completion in
                if case .failure(_) = completion {
                    self?.uiQueue.async {
                        self?.isError = true
                    }
                }
                
                self?.uiQueue.async {
                    self?.isLoading = false
                }
            }
    }
    
    func updateFilters(filtersSelected: Set<String>) {
        self.filtersSelected = filtersSelected
        applyFilter()
    }
    
    private func applyFilter() {
        if filtersSelected.isEmpty {
            taskList = allTasks
        } else {
            taskList = allTasks.filter { task in
                filtersSelected.contains(task.type)
            }
        }
    }
}
