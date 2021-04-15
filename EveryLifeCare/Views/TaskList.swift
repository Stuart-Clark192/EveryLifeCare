//
//  TaskList.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import SwiftUI

struct TaskList: View {
    
    @StateObject private var viewModel: TaskListViewModel
    
    init(viewModel: TaskListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                if viewModel.isLoading {
                    LoadingSpinnerView()
                }
                
                if viewModel.isError {
                    BannerView() {
                        viewModel.fetchTasks()
                    }
                }
            
                List {
                    ForEach(viewModel.taskList, content: TaskView.init)
                }
                .listStyle(PlainListStyle())
                
                FilterBar(filterClicked: { selectedFilters in
                    filterClicked(selectedFilters)
                })
            }
            .navigationBarTitle("Tasks", displayMode: .inline)
        }.onAppear {
            viewModel.fetchTasks()
        }
    }
    
    private func filterClicked(_ filtersSelected: Set<String>) {
        
        viewModel.updateFilters(filtersSelected: filtersSelected)
    }
}

struct TaskList_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = TaskModelBuilder.buildTaskListViewModel()
        TaskList(viewModel: viewModel)
    }
}
