//
//  SQLDatabase+Extensions.swift
//  EveryLifeCareTests
//
//  Created by Stuart on 14/04/2021.
//

import GRDB
@testable import EveryLifeCare

extension SQLDatabase {
    
    func resetDatabase() {
        _ = try? pool.write { db in
            try Task.deleteAll(db)
        }
    }
}

