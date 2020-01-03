//
// Created by Matthias Schicker on 26/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation
import UIKit

class ManageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var kidsTable: UITableView!

    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Core.instance.currentGroup.kids.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "KidCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        let kidCell: KidCell = cell as! KidCell

        kidCell.updateWith(kidId: Core.instance.currentGroup.kids[indexPath.row])

        return kidCell
    }
}
