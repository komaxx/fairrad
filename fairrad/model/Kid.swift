//
// Created by Matthias Schicker on 03/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation
import UIKit

class Kid: CustomStringConvertible {
    let id: String

    var name: String
    var picPath: String?
    var color: UIColor = UIColor.randomColor()

    var history: [HistoryEvent] = [HistoryEvent]()

    init(id: String, name: String, picPath: String?) {
        self.id = id
        self.name = name
        self.picPath = picPath
    }

    var description: String {
        return name
    }
}
