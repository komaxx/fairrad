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

    var highlightedIndexPath : IndexPath?


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(kidsGroupChanged), name: NSNotification.Name.KidsGroupChanged, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func kidsGroupChanged() {
        collectionView.reloadData()
    }

    // ////////////////////////////////////////////////////////
    // delegate / data-source

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let CellIdentifier = "WheelCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath)
            as! SelectWheelCellView

        cell.bind(toKidsGroup: Core.instance.kidsGroups[indexPath.row])
        if (indexPath == highlightedIndexPath){
            styleAsSelected(cell)
        } else {
            styleAsUnselected(cell)
        }

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

        Core.instance.makeGroupCurrent(Core.instance.kidsGroups[indexPath.item])
        let wheelViewController = storyBoard.instantiateViewController(withIdentifier: "MainWheelController")
        present(wheelViewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let prevIndexPath = highlightedIndexPath {
            self.styleAsUnselected(collectionView.cellForItem(at: prevIndexPath))
        }
        self.highlightedIndexPath = indexPath
        self.styleAsSelected(collectionView.cellForItem(at: indexPath))
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let prevIndexPath = highlightedIndexPath {
            self.styleAsUnselected(collectionView.cellForItem(at: prevIndexPath))
        }
        highlightedIndexPath = nil
    }


    private func styleAsSelected(_ item: UICollectionViewCell?) {
        guard let cell = item else {
            return
        }
        cell.backgroundColor = UIColor.darkGray
    }

    private func styleAsUnselected(_ item: UICollectionViewCell?) {
        guard let cell = item else {
            return
        }
        cell.backgroundColor = UIColor.clear
    }
}
