//
// Created by Matthias Schicker on 27/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation
import UIKit

///
/// Shown when the wheel stopped spinning and a kid was picked.
///
class KidPickedView: UIView {
    @IBOutlet weak var kidFaceView: UIImageView!
    @IBOutlet weak var kidNameView: UILabel!
    @IBOutlet weak var kidCenterNameView: UILabel!

    var shownKidId: String = ""


    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.kidFaceView.clipsToBounds = true
        self.kidFaceView.layer.borderWidth = 3
        self.kidFaceView.layer.cornerRadius = self.kidFaceView.frame.size.width / 2
    }

    @IBAction func onAcceptTapped(_ sender: UIButton) {
        Core.instance.currentGroup.kidPicked(id: shownKidId)

        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
            self.kidFaceView.transform = CGAffineTransform(scaleX: 3, y: 3)
        }, completion: { finished in
            self.kidFaceView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            self.isHidden = true
        })
    }

    @IBAction func onDeclineTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
            self.kidFaceView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }, completion: { finished in
            self.isHidden = true
        })
    }

    func show(forKid kid: Kid) {
        shownKidId = kid.id
        kidNameView.text = kid.name
        kidCenterNameView.text = kid.name
        kidFaceView.layer.borderColor = kid.color.cgColor

        if let picPath = kid.picPath {
            kidFaceView.image = UIImage(named: picPath)
        } else {
            kidFaceView.backgroundColor = kid.color
            kidFaceView.image = nil
        }
        kidCenterNameView.isHidden = kidFaceView.image != nil

        self.isHidden = false
        self.alpha = 0

        self.kidFaceView.transform = CGAffineTransform.identity
        self.kidFaceView.alpha = 0;

        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        }, completion: { finished in
            self.appearContent()
        })
    }

    private func appearContent() {
        self.kidFaceView.transform = CGAffineTransform(scaleX: 0.7, y: 0.1)

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: UIView.AnimationOptions.beginFromCurrentState, animations: {
            self.kidFaceView.transform = CGAffineTransform.identity
            self.kidFaceView.alpha = 1
        }, completion: { finished in

        })
    }


}
