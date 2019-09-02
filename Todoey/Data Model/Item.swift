//
//  Item.swift
//  Todoey
//
//  Created by Ajay Sridhar on 9/1/19.
//  Copyright © 2019 Ajay Sridhar. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    // each item has a parent category that comes from a property called "items"
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
