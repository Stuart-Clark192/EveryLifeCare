//
//  SQLDatabase.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import Foundation
import GRDB
import Combine

public class SQLDatabase {
    
    public static let shared = try! SQLDatabase()
    
    private(set) var pool: DatabasePool
    
    private init() throws {
        pool = try SQLDatabase.setupDatabase(inFile: "tasks.sqlite")
        try migrator.migrate(pool)
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        // Speed up development by nuking the database when migrations change
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        // When a GRDB Database is created, there is an additional table created called
        // grdb_migrator, each registered migration has it's name inserted into this table
        // when the migration is run and as such a migration will only be run once
        
        migrator.registerMigration("taskV1.0") { db in
            
            try db.create(table: TableName.task.rawValue) { table in
                table.column("id", .integer).notNull().primaryKey()
                table.column("name", .text)
                table.column("description", .text)
                table.column("type", .text)
            }
        }
        
        // Register future migrations here, for example to add a new field to the above
        // created table we could use
//        migrator.registerMigration("taskV1.1") { db in
//
//            try db.alter(table: TableName.task.rawValue) { table in
//                table.add(column: "hasCompleted", .boolean).defaults(to: false).notNull()
//            }
//        }
        
        return migrator
    }
    
    private static func setupDatabase(inFile file:String) throws -> DatabasePool {
        let databaseURL = try FileManager.default
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent(file)
        return try DatabasePool(path: databaseURL.path)
    }
    
    public func dataObserver() -> AnyPublisher<[Task], Never> {
        
        // Track all task changes on the database

        ValueObservation
            .trackingConstantRegion { database -> [Task] in
                return try Task.fetchAll(database)
            }
            .publisher(in: pool)
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}

