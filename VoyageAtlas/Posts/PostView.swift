//
//  PostView.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct PostView: View {
    @State var post: Post
    var body: some View {
        VStack {
            HStack {
                ProfilePicture(width: 75, height: 75)
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Text("@JosueMorales")
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text(post.convertCreatedAt())
                            .font(.caption2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 75)
                .padding(.trailing, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Text(post.content)
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
        PostView(post: Post(
            title: "Joshua Tree National Park is Amazing!",
            location: "",
            content: "Joshua Tree has amazing hikes and beautiful star gazing",
            id: "",
            author: "",
            created_at: 231213
        ))
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
