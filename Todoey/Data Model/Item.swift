//
//  Item.swift
//  Todoey
//
//  Created by Churong Zhang on 2/25/19.
//  Copyright © 2019 Churong Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
