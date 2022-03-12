//
//  Storage.swift
//  fairrad
//
//  Created by Matthias Schicker on 12.03.22.
//  Copyright © 2022 Matthias Schicker. All rights reserved.
//

import Foundation

class Storage {
    func loadHistoryEvents(forGroupId groupId: String) -> [HistoryEvent]? {
        let rawLoaded = UserDefaults.standard.object(forKey: "history_\(groupId)")
        guard let loaded = rawLoaded as? [Dictionary<String, Any>] else {
            print("No data stored for group \(groupId)")
            return nil
        }
        print("Loaded \(loaded.count) dicitonaries for \(groupId)")
        return loaded.map{ HistoryEvent.from(dicitonary: $0) }
    }
    
    func storeHistory(_ events: [HistoryEvent], ofGroupId groupId: String) {
        UserDefaults.standard.set(events.map{ $0.toDictionary() },
                                  forKey: "history_\(groupId)")
        print("Stored \(events.count) for \(groupId)")
    }
}

