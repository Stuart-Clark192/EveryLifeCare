//
//  XCTestCase+MemoryLeakTracking.swift
//  EveryLifeCareTests
//
//  Created by Stuart on 14/04/2021.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject,
                                     file: StaticString = #file,
                                     line: UInt = #line) {
        
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

