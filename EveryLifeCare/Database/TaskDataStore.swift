//
//  TaskDataStore.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation

protocol TaskDataStore {
    
    func saveTasks(tasks: [Task]) throws
}
