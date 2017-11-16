//
//  classData.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/10/18.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import Foundation
import RealmSwift

class classData:Object {
    var uuid:String = UUID().uuidString
    var classTitle:String = ""
    var classSteps:List<classStep> = List<classStep>()
    var coverImg:NSData = NSData()
    
    override static func primaryKey() -> String {
        return "uuid"
    }
}
