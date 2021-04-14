//
//  LoadingSpinnerView.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import SwiftUI

struct LoadingSpinnerView: View {
    var body: some View {
        ZStack {
            Text("Refreshing Data")
                .font(.caption)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .trailing)
                .padding(.trailing)
        }.background(Color.green)
        .transition(.move(edge: .top))
        .animation(.easeIn(duration: 0.6))
        
    }
}

struct LoadingSpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinnerView()
    }
}
