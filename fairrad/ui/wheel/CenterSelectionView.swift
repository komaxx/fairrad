//
// Created by Matthias Schicker on 14/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import UIKit

class CenterSelectionView: UIView {
    @IBOutlet weak var kidFaceView: UIImageView!
    @IBOutlet weak var kidNameView: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.clipsToBounds = true

        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 3
    }

    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.width / 2
        super.layoutSubviews()
    }

    func update(withKidId kidId: String?) {
        guard let kidID = kidId,
              let kid = Core.instance.kid(withId: kidID) else {
            self.backgroundColor = UIColor.clear
            return
        }

        self.backgroundColor = kid.color
        self.layer.borderColor = kid.color.cgColor

        self.kidNameView.text = kid.name
        if let picPath = kid.picPath {
            self.kidFaceView.image = UIImage(named: picPath)
        } else {
            self.kidFaceView.image = nil
        }

        self.transform = CGAffineTransform(scaleX: 1.04, y: 0.96)

        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
