//
// Created by Matthias Schicker on 04/03/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation
import UIKit

class SelectViewController : UIViewController
        , UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var collectionView: UICollectionView!


    // ////////////////////////////////////////////////////////
    // delegate / data-source

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let CellIdentifier = "WheelCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath)
            as! SelectWheelCellView

        cell.bind(toKidsGroup: Core.instance.currentGroup)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // go to wheel view

        print("YAY selected.")

    }

}
