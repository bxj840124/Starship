//
//  collectionData.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/10/25.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import Foundation
import RealmSwift

class collectionData:Object {
    var uuid:String = UUID().uuidString
    var classes:List<classData> = List<classData>()
    
    override static func primaryKey() -> String {
        return "uuid"
    }
}
