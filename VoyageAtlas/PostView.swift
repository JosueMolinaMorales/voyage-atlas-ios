//
//  PostView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        VStack {
            HStack {
                ProfilePicture(width: 75, height: 75)
                VStack(alignment: .leading) {
                    Text("Joshua Tree National Park Is Amazing!")
                        .font(.headline)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text("@JosueMorales")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("1:00PM 12/12/23")
                            .font(.caption2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 75)
                .padding(.trailing, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text(" Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse porttitor non urna in feugiat. Donec id suscipit turpis, a varius ex. Duis tempor tellus eget enim fringilla tincidunt. Donec a aliquam nunc, eget ullamcorper sem. Aliquam rutrum nec ipsum a tempus. Nullam id dictum tellus...")
                    .font(.body)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 8)
            
            HStack {
                Image("JoshTree1")
                    .resizable()
                    .frame(width: 100, height: 100)
                Image("JoshTree2")
                    .resizable()
                    .frame(width: 100, height: 100)
                Image("JoshuaTree")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}

/*
 Image("JoshuaTree")
     .resizable()
     .frame(width: 150, height: 100)
     .clipShape(RoundedRectangle(cornerRadius: 10))
     .aspectRatio(contentMode: .fit)
     .shadow(radius: 7)
 */
