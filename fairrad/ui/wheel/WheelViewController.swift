//
//  WheelViewController.swift
//  fairrad
//
//  Created by Matthias Schicker on 31/01/2017.
//  Copyright © 2017 Matthias Schicker. All rights reserved.
//

import UIKit
import AVFoundation

import AudioToolbox.AudioServices


class WheelViewController: UIViewController, WheelViewDelegate {
    @IBOutlet weak var wheelView: WheelView!

    @IBOutlet weak var centerView: CenterSelectionView!

    @IBOutlet weak var topIndicator: UIImageView!

    @IBOutlet weak var kidPickedView: KidPickedView!

    let tickGenerator = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wheelView.delegate = self
        self.centerView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tickGenerator.prepare()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(self,
                selector: #selector(kidsGroupChanged),
                name: NSNotification.Name.KidsGroupChanged, object: nil)

        self.wheelView.update(withGroup: Core.instance.currentGroup)
    }

    @objc func kidsGroupChanged() {
        self.wheelView.update(withGroup: Core.instance.currentGroup)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        super.viewWillDisappear(animated)
    }

    @IBAction func backToSelectionTapped(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func manageButtonTapped(_ sender: Any) {
        guard let storyBoard = self.storyboard else {
            print("No storyboard! Not jumping to next screen.")
            return
        }

        let manageViewController = storyBoard.instantiateViewController(withIdentifier: "ManageViewController")
        present(manageViewController, animated: true)
    }

    // /////////////////////////////////////////////////////////////////
    // wheel view delegate

    func higlightedKidChanged(nuKidId: String?, angleSpeed: Double) {
        centerView.update(withKidId: nuKidId)

        self.topIndicator.transform = CGAffineTransform(rotationAngle: (((angleSpeed > 0) ? -1 : 1) * (CGFloat.pi / 20)))
        UIView.animate(withDuration: 0.1, animations: {
            self.topIndicator.transform = CGAffineTransform.identity
        })

        playTick()
    }

    func kidPicked(withId id: String?) {
        guard let id = id, let kid = Core.instance.kid(withId: id) else {
            print("No id or no kid. Shite.")
            return
        }

        kidPickedView.show(forKid: kid)
    }

    private func playTick() {
        tickGenerator.selectionChanged()
        
        // 1157: Magic number from the internet :/
        // Seems to work reliably, though
        AudioServicesPlaySystemSoundWithCompletion(1157, nil)
    }
}

