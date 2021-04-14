//
//  TaskView.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import SwiftUI

struct TaskView: View {
    
    let task: Task
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                Image(task.type)
                    .frame(width: 35.0, height: 35.0)
            }
            VStack(alignment: .leading)  {
                Text(task.name)
                    .font(.title)
                
                Text(task.description)
                    .foregroundColor(.secondary)
                    .padding(.top, 1)
                    
            }.padding([.bottom, .trailing])
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        let task = Task(id: 1, name: "Take the rubbish out", description: "Empty the bin and take the rubbish and recycling to the communal rubbish bins that are on the lower ground floor of the building", type: "hydration")
        TaskView(task: task)
    }
}
