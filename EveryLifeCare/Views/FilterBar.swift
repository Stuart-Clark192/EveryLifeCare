//
//  FilterBar.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import SwiftUI

struct FilterBar: View {
    
    @State var selectedFilters: Set<String> = []
    var filterClicked: (_ selectedFilters: Set<String>) -> ()
    
    var filters = ["general", "medication", "hydration", "nutrition"]
    
    var body: some View {
        HStack {
            ForEach(filters, id: \.self) { filterName in
                ZStack {
                    Image(filterName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35.0, height: 35.0, alignment: .center)
                        .padding(5)
                        .onTapGesture {
                            if selectedFilters.contains(filterName) {
                                selectedFilters.remove(filterName)
                            }  else {
                                selectedFilters.insert(filterName)
                            }
                            filterClicked(selectedFilters)
                        }
                    
                    Circle()
                        .strokeBorder(selectedFilters.contains(filterName) ? Color.green : Color.clear ,lineWidth: 1)
                        .frame(width: 50.0, height: 50.0, alignment: .center)
                }
            }
        }
    }
}

struct FilterBar_Previews: PreviewProvider {
    static var previews: some View {
        FilterBar(filterClicked: { _ in} )
    }
}
