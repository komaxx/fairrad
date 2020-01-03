//
// Created by Matthias Schicker on 03/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation
import UIKit

class Core {

    // //////////////////////////////////////////////////////////
    // singleton

    static public let instance = Core()

    // singleton
    // //////////////////////////////////////////////////////////

    private(set) var currentGroup: KidsGroup

    private(set) var kidsGroups = [KidsGroup]()
    private var kids = [String: Kid]()

    private let groupsSorterByLastAccess: (KidsGroup, KidsGroup) -> Bool = { a, b in
        if a.lastTimeCurrent == b.lastTimeCurrent {
            // Special case: Same age. sort by id as fallback
            // TODO
        }
        return a.lastTimeCurrent.timeIntervalSince(b.lastTimeCurrent) > 0
    }


    private init() {
        currentGroup = KidsGroup(name: "initial group", style: .chances_stay_the_same)

        loadData()

        if kids.count < 1 {
            createInitialData()
        }
    }

    private func loadData() {
        // TODO
    }

    func kid(withId kidId: String) -> Kid? {
        return kids[kidId]
    }

    func group(withId groupId: String) -> KidsGroup? {
        return kidsGroups.first { group in
            group.id == groupId
        }
    }

    func makeGroupCurrent(_ nuCurrent: KidsGroup) {
        guard currentGroup != nuCurrent else {
            print("Already current.")
            return
        }

        if !kidsGroups.contains(nuCurrent) {
            print("Unknown group! Will be added to list of known kidsGroups.")
            kidsGroups.append(nuCurrent)
        }

        self.currentGroup = nuCurrent
        self.currentGroup.setCurrent()

        // reactivate when notification implemented. Otherwise: View and Core go unsynced!
        // self.kidsGroups = self.kidsGroups.sorted(by: groupsSorterByLastAccess)
    }

    /// Shortcut where name and picPath are the same
    private func addKid(name: String) -> Kid {
        return addKid(name: name, picPath: name)
    }

    private func addKid(name: String, picPath: String) -> Kid {
        return addKid(id: (UUID().uuidString), name: name, picPath: picPath)
    }

    private func addKid(id: String, name: String, picPath: String?) -> Kid {
        guard self.kid(withId: id) == nil else {
            print("NOT adding kid with id \(id). Already exists!")
            return self.kid(withId: id)!
        }

        let nuKid = Kid(id: id, name: name, picPath: picPath)
        kids[nuKid.id] = nuKid
        return nuKid
    }

    // /////////////////////////////////////////////////////////////
    // initial data

    private func createInitialData() {
        let sitCircleGroup = KidsGroup(name: "Sitzkreis", style: .slowly_recover_chance)
        sitCircleGroup.appendKid(self.addKid(name: "Emily").id)
        sitCircleGroup.appendKid(self.addKid(name: "Erik").id)
        sitCircleGroup.appendKid(self.addKid(name: "Gregor").id)
        sitCircleGroup.appendKid(self.addKid(name: "Julia").id)
        sitCircleGroup.appendKid(self.addKid(name: "Lara").id)
        sitCircleGroup.appendKid(self.addKid(name: "Linus").id)
        sitCircleGroup.appendKid(self.addKid(name: "Lisa").id)
        sitCircleGroup.appendKid(self.addKid(name: "Luke").id)
        sitCircleGroup.appendKid(self.addKid(name: "Manvi").id)
        sitCircleGroup.appendKid(self.addKid(name: "Mia").id)
        sitCircleGroup.appendKid(self.addKid(name: "Miguel").id)
        sitCircleGroup.appendKid(self.addKid(name: "Niklas").id)
        sitCircleGroup.appendKid(self.addKid(name: "Nikolaus").id)
        sitCircleGroup.appendKid(self.addKid(name: "Noa").id)
        sitCircleGroup.appendKid(self.addKid(name: "Paula").id)
        sitCircleGroup.appendKid(self.addKid(name: "Philip B.", picPath: "PhilipB.").id)
        sitCircleGroup.appendKid(self.addKid(name: "Philip R.", picPath: "PhilipR.").id)
        sitCircleGroup.appendKid(self.addKid(name: "Quentin").id)
        sitCircleGroup.appendKid(self.addKid(name: "Quirin").id)
        sitCircleGroup.appendKid(self.addKid(name: "Sophia").id)
        sitCircleGroup.appendKid(self.addKid(name: "Vincent").id)
        self.kidsGroups.append(sitCircleGroup)

        // make the kids rainbow colored for the beginning
        let hueDelta: CGFloat = 1.0 / CGFloat(sitCircleGroup.kids.count)
        var hue: CGFloat = 0
        for kidId in sitCircleGroup.kids {
            self.kids[kidId]!.color = UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1)
            hue += hueDelta
        }


        let yesOrNoGroup = KidsGroup(name: "Ja oder nein", style: .chances_stay_the_same)
        let yes1 = addKid(id: "yes_green_1", name: "JA", picPath: nil)
        yes1.color = UIColor.init(red: 0, green: 0.6, blue: 0, alpha: 1)
        yesOrNoGroup.appendKid(yes1.id)

        let no1 = addKid(id: "no_red_1", name: "NEIN", picPath: nil)
        no1.color = UIColor.init(red: 0.6, green: 0, blue: 0, alpha: 1)
        yesOrNoGroup.appendKid(no1.id)

        let yes2 = addKid(id: "yes_green_2", name: "JA", picPath: nil)
        yes2.color = UIColor.init(red: 0, green: 0.6, blue: 0, alpha: 1)
        yesOrNoGroup.appendKid(yes2.id)

        let no2 = addKid(id: "no_red_2", name: "NEIN", picPath: nil)
        no2.color = UIColor.init(red: 0.6, green: 0, blue: 0, alpha: 1)
        yesOrNoGroup.appendKid(no2.id)

        self.kidsGroups.append(yesOrNoGroup)
    }
}
