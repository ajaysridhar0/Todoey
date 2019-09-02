//
//  Category.swift
//  Todoey
//
//  Created by Ajay Sridhar on 9/1/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
