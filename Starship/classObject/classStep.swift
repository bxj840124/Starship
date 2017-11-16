//
//  classStep.swift
//  Starship
//
//  Created by 楊喬宇 on 2017/10/18.
//  Copyright © 2017年 楊喬宇. All rights reserved.
//

import Foundation
import RealmSwift

class classStep:Object {
    var stepImg:NSData = NSData()
    var stepNum:Int = 0
    var stepTitle:String = ""
    var stepContent:String = ""
}
