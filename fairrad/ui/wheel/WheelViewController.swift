//
//  WheelViewController.swift
//  fairrad
//
//  Created by Matthias Schicker on 31/01/2017.
//  Copyright © 2017 Matthias Schicker. All rights reserved.
//

import UIKit
import AVFoundation


class WheelViewController: UIViewController, WheelViewDelegate {
    @IBOutlet weak var wheelView: WheelView!

    @IBOutlet weak var centerView: CenterSelectionView!

    @IBOutlet weak var topIndicator: UIImageView!

    @IBOutlet weak var kidPickedView: KidPickedView!


    // Grab the path, make sure to add it to your project!

    //var tickPlayers = [AVAudioPlayer]()
    var nextPlayer = 0


    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            for _ in 0...5 {
//                let tickSoundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "tick2", ofType: "wav")!)
//                let nuPlayer = try AVAudioPlayer(contentsOf: tickSoundURL)
//                //nuPlayer.numberOfLoops = -1
//                nuPlayer.prepareToPlay()
//                nuPlayer.volume = 0.1
//                tickPlayers.append(nuPlayer)
            }
        } catch {
            print("Shoot :<")
            print(error)
        }
        self.wheelView.delegate = self
        self.centerView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
//        DispatchQueue.global().async {
//            for player in self.tickPlayers {
//                if !player.isPlaying {
//                    player.play()
//                    break
//                }
//            }
//        }
    }
}

