//
//  BannerView.swift
//  EveryLifeCare
//
//  Created by Stuart on 14/04/2021.
//

import SwiftUI

struct BannerView: View {
    
    var refresh: () -> ()
    
    var body: some View {
        HStack {
        Text("Error Refreshing data, please check your connection")
            .font(.caption)
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .center)
            
            Image(systemName: "arrow.clockwise.circle")
                .padding(.trailing)
        }.background(Color.red)
        .transition(.move(edge: .top))
        .animation(.easeIn(duration: 0.6))
        .onTapGesture {
            refresh()
        }
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView() {
            
        }
    }
}
