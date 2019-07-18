//
//  Category.swift
//  Todoey
//
//  Created by Churong Zhang on 2/25/19.
//  Copyright © 2019 Churong Zhang. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String = ""
    let items = List<Item>()
}
