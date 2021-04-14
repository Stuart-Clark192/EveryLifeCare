//
//  EveryLifeCareApp.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import SwiftUI

@main
struct EveryLifeCareApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = TaskModelBuilder.buildTaskListViewModel()
            TaskList(viewModel: viewModel)
        }
    }
}
