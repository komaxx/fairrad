//
// Created by Matthias Schicker on 04/03/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation
import UIKit

class SelectWheelCellView : UICollectionViewCell {
    @IBOutlet weak var wheeeeel: WheelView!


    func bind(toKidsGroup kidsGroup: KidsGroup) {
        wheeeeel.setToSmallMode(active: true)
        wheeeeel.update(withGroup: kidsGroup)
    }
}
