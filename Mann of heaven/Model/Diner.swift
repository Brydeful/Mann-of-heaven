//
//  Diner.swift
//  Mann of heaven
//
//  Created by Вячеслав on 08.12.2019.
//  Copyright © 2019 Вячеслав. All rights reserved.
//

import Foundation

struct Diner: Codable {
    var id: Int
    var sizeIndex: Int
    var time: String
    
    enum CodingKeys: String, CodingKey{
        case id
        case sizeIndex = "size"
        case time = "date"
    }
    
    var size: String{
        let sizeArray = ["Маленькая","Средняя","Большая"]
        return sizeArray[sizeIndex]
    }
}
