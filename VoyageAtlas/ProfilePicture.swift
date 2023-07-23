//
//  ProfilePicture.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/23/23.
//

import SwiftUI

struct ProfilePicture: View {
    var body: some View {
        Image("ProfilePic")
            .resizable()
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
            .shadow(radius: 7)
    }
}

struct ProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicture()
    }
}
