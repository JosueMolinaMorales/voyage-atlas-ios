//
//  PostView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        HStack {
            Image("JoshuaTree")
                .resizable()
                .frame(width: 150, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 7)

            VStack(alignment: .leading) {
                Text("My Post Title")
                    .font(.title)
                Text("Content Preview....")
                    .font(.subheadline)
            }.padding(.leading, 8.0)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
