//
//  Item.swift
//  Todoey
//
//  Created by Ajay Sridhar on 8/28/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String = ""
    var done: Bool = false
    
    init() {
        
    }
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
}
