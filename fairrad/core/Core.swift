//
// Created by Matthias Schicker on 03/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import Foundation

class Core {

    // //////////////////////////////////////////////////////////
    // singleton

    static public let instance = Core()

    // singleton
    // //////////////////////////////////////////////////////////

    private(set) var currentGroup : KidsGroup;

    private var kids = [String : Kid]()


    private init(){
        currentGroup = KidsGroup(name:"initial group", style: .chances_stay_the_same)

        createFakeData()
    }

    func replaceCurrentKidGroupWithFakes() {
//        currentGroup = KidsGroup.createTestGroup()
    }

    func kid(withId kidId: String) -> Kid? {
        return kids[kidId]
    }

    // //////////////////////////////////////////////////////////
    // dev / debug

    func createFakeData(){
        // create some fake kids
        self.addFakeKid(name: "Adam A1")
        self.addFakeKid(name: "Adam A 1")
        self.addFakeKid(name: "Bertha B 2")
        self.addFakeKid(name: "Christian Christiansonlangname 3")
        self.addFakeKid(name: "Daniela Damaskus 4")
        self.addFakeKid(name: "Elon Emission 5")
        /*
        self.addFakeKid(name: "Franziska Freitag 6")
        self.addFakeKid(name: "Gustav Grain 7")
        self.addFakeKid(name: "Hannelore Heimlich 8")
        self.addFakeKid(name: "Irina Immelheim 9")
        self.addFakeKid(name: "Josef Jämmerlich 10")
        self.addFakeKid(name: "Karla Katastrophe 11")

        self.addFakeKid(name: "A*dam A 12")
        self.addFakeKid(name: "B*ertha B 13")
        self.addFakeKid(name: "C*hristian Christianson 14")
        self.addFakeKid(name: "D*aniela Damaskus 15")
        self.addFakeKid(name: "E*lon Emission 16")
        self.addFakeKid(name: "F*ranziska Freitag 17")
        self.addFakeKid(name: "G*ustav Grain 18")
        self.addFakeKid(name: "H*annelore Heimlich 19")
        self.addFakeKid(name: "I*rina Immelheim 20")
        self.addFakeKid(name: "J*osef Jämmerlich 21")
        self.addFakeKid(name: "K*arla Katastrophe 22")
        */

        // put them in a fake group
        let testGroup = KidsGroup(name: "Test group", style: .gone_until_everybody_had_its_turn)

        var iterator = kids.keys.makeIterator()
        for _ in 0..<(min(50, kids.count)) {
            let kidId = iterator.next()!
            testGroup.appendKid(kidId)
        }

        self.currentGroup = testGroup
    }

    private func addFakeKid(name: String) {
        let nuKid = Kid(name: name, picPath:"picpath \(kids.count)")
        kids[nuKid.id] = nuKid
    }
}
