//
//  Post.swift
//  Mann of heaven
//
//  Created by Вячеслав on 08.06.2018.
//  Copyright © 2018 Вячеслав. All rights reserved.
//

import Foundation

struct Post {
    
    var size: String
    var date: String
    
    init?(json: [String: Any]) {
        
        guard
            let size = json["size"] as? String,
            let date = json["date"] as? String
            else {
                return nil
        }
        
        self.size = size
        self.date = date
    }
    
    static func getArray(from jsonArray: Any) -> [Post]? {
        
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var posts: [Post] = []
        
        for jsonObject in jsonArray {
            if let post = Post(json: jsonObject) {
                posts.append(post)
            }
        }
        return posts
    }
}

