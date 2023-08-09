//
//  HeaderView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/29/23.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Image("VoyageBoat")
                .resizable()
                .frame(width: 35, height: 35)
        }.padding(.init(top: 4, leading: 0, bottom: 8, trailing: 0))
        .frame(maxWidth: .infinity)
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
