//
//  ViewController.swift
//  GenericNetwork
//
//  Created by Karolina Muñoz on 06/19/2021.
//  Copyright (c) 2021 Karolina Muñoz. All rights reserved.
//

import UIKit
import GenericNetwork

class ViewController: UIViewController {

    var client: Client?
    let session = URLSession.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        client = Client(session: session)
        client?.put(url: "https://jsonplaceholder.typicode.com/posts/1", type: Post.self, object: Post(id: 1, userId: 1, title: "titleUpdated", body: "bodyUpdated")) {
            result in
            print(result)
        }
        client?.post(url: "https://jsonplaceholder.typicode.com/posts", type: Post.self, object: Post(userId: 1, title: "title", body: "body")) {
            result in
            print(result)
        }
        client?.get(url: "https://jsonplaceholder.typicode.com/posts", type: [Post].self ) {
            result in
            print(result)
        }
        client?.delete(url: "https://jsonplaceholder.typicode.com/posts/1") {
            result in
            print(result)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

