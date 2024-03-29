//
// Created by Matthias Schicker on 03/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation

///
/// A kid was chosen.
///
class HistoryEvent {
    private(set) var chosenKid: String
    private(set) var timeStamp: Date

    init(withChosenKid kid: String, timeStamp: Date) {
        self.chosenKid = kid
        self.timeStamp = timeStamp
    }
    
    func toDictionary() -> [String:Any] {
        return ["kidId": chosenKid, "timeStamp": timeStamp]
    }
    
    class func from(dicitonary: [String:Any]) -> HistoryEvent {
        return HistoryEvent(withChosenKid: dicitonary["kidId"] as! String,
                            timeStamp: dicitonary["timeStamp"] as! Date)
    }
}
