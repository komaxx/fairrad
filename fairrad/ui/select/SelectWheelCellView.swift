//
// Created by Matthias Schicker on 04/03/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation
import UIKit

class SelectWheelCellView: UICollectionViewCell {
    @IBOutlet weak var wheeeeel: WheelView!
    @IBOutlet weak var groupName: UILabel!


    func bind(toKidsGroup kidsGroup: KidsGroup) {
        groupName.text = kidsGroup.name

        wheeeeel.setToSmallMode(active: true)
        wheeeeel.update(withGroup: kidsGroup)
    }
}
