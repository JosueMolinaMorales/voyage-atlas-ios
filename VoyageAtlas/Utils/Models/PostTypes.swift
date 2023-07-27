//
//  PostTypes.swift
//  VoyageAtlas
//
//  Created by Josue morales on 7/27/23.
//

import Foundation

struct CreatePost: Encodable {
    var title: String = ""
    var location: String = ""
    var content: String = ""
}
