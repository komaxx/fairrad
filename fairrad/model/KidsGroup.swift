//
// Created by Matthias Schicker on 03/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation


enum KidsGroupStyle {
    case gone_until_everybody_had_its_turn
    case slowly_recover_chance
    case chances_stay_the_same
}

extension Notification.Name {
    static let KidsGroupChanged = Notification.Name("kidsGroupChanged")
}

///
/// A group of kids. Like a class. But without being a protected keyword.
///
class KidsGroup : Equatable {
    private(set) var id : String

    private(set) var name : String
    private(set) var style : KidsGroupStyle
    private(set) var kids : [String] = [String]()

    private(set) var history : [HistoryEvent] = [HistoryEvent]()

    /// computed from history
    private(set) var kidWeights : [String:Int] = [String:Int]()

    private(set) var lastTimeCurrent : Date


    init(name: String, style:KidsGroupStyle){
        self.id = UUID().uuidString

        self.name = name
        self.style = style

        self.lastTimeCurrent = Date.distantPast
    }

    ///
    /// Numeric value in [0,kidsCount] where 0 means: Do not show at all.
    /// All other values are to be considered in relation to other weights
    ///
    func weightForKid(withId id: String) -> Int {
        guard let weight = kidWeights[id] else {
            print("No weight for kid with id \(id) (yet). Resetting.")
            resetWeightForKid(id)
            return kidWeights[id]!
        }
        return weight
    }

    ///
    /// Sums up the weight of all kids in the group
    ///
    func getOverallWeight() -> Int {
        return max(1, kids.reduce(0, { $0 + weightForKid(withId: $1) }) )
    }

    func appendKid(_ id: String) {
        kids.append(id)
        recomputeWeights()

        self.notify()
    }

    func kidPicked(id: String) {
        guard kids.contains(id) else {
            print("Kid \(id) is not part of this group!")
            return
        }

        let nuEvent = HistoryEvent(withChosenKid: id, timeStamp: Date())
        self.history.append(nuEvent)
        self.executeHistoryEvent(nuEvent)
        self.notify()
    }

    private func recomputeWeights() {
        resetAllWeights()

        // now, replay the history
        for historyEvent in history {
            executeHistoryEvent(historyEvent)
        }
    }

    private func resetAllWeights() {
        kidWeights.removeAll(keepingCapacity: true)
        for id in kids {
            resetWeightForKid(id)
        }
    }

    private func resetWeightForKid(_ id: String) {
        self.kidWeights[id] = self.kids.count
    }

    ///
    /// 'Executes' a single history event, i.e. calculates new kid weights
    /// based on the current state in the group
    ///
    private func executeHistoryEvent(_ event : HistoryEvent) {
        if style == .gone_until_everybody_had_its_turn {
            kidWeights[event.chosenKid] = 0
            if getOverallWeight() < 1 {
                resetAllWeights()
            }
        } else if style == .slowly_recover_chance {
            for kid in kids {
                kidWeights[kid] = weightForKid(withId: kid) + 1
            }
            kidWeights[event.chosenKid] = 1
        } // else: keep all weights the same
    }

    ///
    /// Delivers the latest history event for the given kidId in this
    /// group - if present
    ///
    func getLatestHistoryEventForKid(kidId: String) -> HistoryEvent? {
        return history.reversed().first { e in kidId == e.chosenKid  }
    }

    private func notify() {
        NotificationCenter.default.post(name: NSNotification.Name.KidsGroupChanged, object: nil)
    }

    func setCurrent() {
        self.lastTimeCurrent = Date()
    }

    ///
    /// Equatable
    ///
    static func ==(lhs: KidsGroup, rhs: KidsGroup) -> Bool {
        return lhs.id==rhs.id
    }
}
