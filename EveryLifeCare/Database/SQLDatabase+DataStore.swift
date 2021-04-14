//
//  SQLDatabase+DataStore.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation
import GRDB

extension SQLDatabase: TaskDataStore {
    
    public func saveTasks(tasks: [Task]) throws {
        try pool.write { database in
            try tasks.forEach { task in
                try task.save(database)
            }
        }
    }
}

