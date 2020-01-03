//
// Created by Matthias Schicker on 26/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation
import UIKit

class KidCell: UITableViewCell {
    @IBOutlet weak var rootView: UIView!

    @IBOutlet weak var faceView: UIImageView!
    @IBOutlet weak var nameView: UILabel!

    @IBOutlet weak var lastPickView: UILabel!

    @IBOutlet weak var leftBarView: UIView!
    @IBOutlet weak var rightBarView: UIView!


    static var lastPickDateFormatter: DateFormatter!


    func updateWith(kidId: String) {
        guard let kid = Core.instance.kid(withId: kidId) else {
            print("Kid with if \(kidId) not found!")
            return
        }

        leftBarView.backgroundColor = kid.color
        rightBarView.backgroundColor = kid.color
        //faceView.
        nameView.text = kid.name

        if let latestHistoryEvent = Core.instance.currentGroup.getLatestHistoryEventForKid(kidId: kidId) {
            if KidCell.lastPickDateFormatter == nil {
                KidCell.lastPickDateFormatter = DateFormatter()
                KidCell.lastPickDateFormatter.dateFormat = "dd-MM-yy"
            }
            lastPickView.text = "zuletzt: \(KidCell.lastPickDateFormatter!.string(from: latestHistoryEvent.timeStamp))"
        } else {
            lastPickView.text = "hat noch nie gewonnen"
        }
    }
}
