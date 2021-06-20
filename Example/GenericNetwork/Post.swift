//
//  Post.swift
//  GenericNetwork_Example
//
//  Created by Karolina Muñoz Vargas on 19/6/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

struct Post: Codable {
    var id: Int?
    var userId: Int
    var title: String
    var body: String
}
