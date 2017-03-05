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

        cell.bind(toKidsGroup: Core.instance.kidsGroups[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Core.instance.kidsGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // go to wheel view
        guard let storyBoard = self.storyboard else {
            print("No storyboard! Not jumping to next screen.")
            return
        }

        print("Index path row: \(indexPath.row), item: \(indexPath.item)")
        
        Core.instance.makeGroupCurrent(Core.instance.kidsGroups[indexPath.row])
        let wheelViewController = storyBoard.instantiateViewController(withIdentifier: "MainWheelController")
        present(wheelViewController, animated: true)
    }

}
