//
//  WheelView.swift
//  fairrad
//
//  Created by Matthias Schicker on 31/01/2017.
//  Copyright © 2017 Matthias Schicker. All rights reserved.
//

import UIKit
import QuartzCore

protocol WheelViewDelegate {
    func higlightedKidChanged(nuKidId: String?, angleSpeed:Double)
    func kidPicked(withId id: String?)
}

class WheelView : UIView , UIGestureRecognizerDelegate {
    let FOCUS_ANGLE = (Float.pi*0.5)

    /// The angular speed will be multiplied with this per frame
    let SLOW_DOWN_FACTOR = 0.985

    /// when the angular speed falls under this, the movement is considered 'stopped'
    let STOP_SPEED = 0.025

    var kidsGroupId : String?
    var sectorViews : [String:SectorView] = [String:SectorView]()

    var displayLink : QuartzCore.CADisplayLink?

    let spinHistory = SpinHistory()
    var touchDownRadians : CGFloat = 0
    var lastTouchTimeStamp : Date = Date()

    var highlightedSectorView : SectorView?
    var currentRadians : CGFloat = 0

    /// degree radians per second
    var currentAngleSpeed : Double = 0

    var delegate : WheelViewDelegate?

    var smallMode = false


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.autoresizesSubviews = false
        //self.clipsToBounds = true

        self.backgroundColor = UIColor.clear

        let recognizer = UIPanGestureRecognizer(target:self, action:#selector(panning))
        recognizer.minimumNumberOfTouches = 1
        recognizer.maximumNumberOfTouches = 2
        recognizer.delegate = self;
        addGestureRecognizer(recognizer)

        // make it tumble! Tumbling is fun :)
        self.layer.anchorPoint = CGPoint(x:0.496, y:0.504)
    }

    func setToSmallMode(active : Bool){
        guard self.smallMode != active else {
            return
        }
        self.smallMode = active
    }

    // //////////////////////////////////////////////////////////////////
    // interaction

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }

    func panning(gestureRecognizer: UIGestureRecognizer) {
        let touchLoc = gestureRecognizer.location(in: self)

        let deltaX = touchLoc.x - bounds.width/2
        let deltaY = touchLoc.y - bounds.height/2

        let angle = atan2(deltaY, deltaX)

        stopAnimation()
        let state=gestureRecognizer.state;
        if state == .began{
            touchDownRadians = angle
        } else if (state == .ended) || (state == .cancelled) {
            if self.spinHistory.shouldSpin(){
                currentAngleSpeed = self.spinHistory.getAngleSpeed()
                startAnimation()
            } else {
                stopAndPick()
            }
        } else {
            // the view is turned with the touches, so touchdown-radians is *always*
            // the touch-radians of the last frame, too
            var deltaRadians = angle-touchDownRadians

            if abs(deltaRadians+2*CGFloat.pi) < abs(deltaRadians){
                deltaRadians += 2*CGFloat.pi
            } else if abs(deltaRadians-CGFloat.pi) < abs(deltaRadians){
                deltaRadians -= 2*CGFloat.pi
            }

            self.updateCurrentRadians(currentRadians + deltaRadians)
            self.transform = CGAffineTransform(rotationAngle: currentRadians)
        }

        lastTouchTimeStamp = Date()
    }

    private func updateCurrentRadians(_ nuRadians : CGFloat) {
        self.currentRadians = clipToUnitCircle(angle: nuRadians)
        self.spinHistory.addEntry(currentRadians)

        self.recomputeHighlightedKid();
    }

    private func findSectorForAngle(_ radians: Float) -> SectorView? {
        if sectorViews.count < 1 {
            return nil
        }

        var adjustedRadians = radians

        adjustedRadians = clipToUnitCircle(angle:(2*Float.pi) - radians)
        for sectorView in sectorViews.values {
            let activeArea = (sectorView.targetRadians-sectorView.radianSpan/2, sectorView.targetRadians+sectorView.radianSpan/2)
            if adjustedRadians >< activeArea{
                return sectorView;
            }
        }
        return nil
    }

    func recomputeHighlightedKid() {
        var focusAngle = ( Float(currentRadians) + FOCUS_ANGLE )
        focusAngle = clipToUnitCircle(angle: Float(focusAngle))
        let nowHighlightedSector = smallMode ? nil : self.findSectorForAngle(focusAngle)

        // print("radians: \(nuRadians) found: \(nowHighlightedSector)")

        if nowHighlightedSector != self.highlightedSectorView {
            self.highlightedSectorView?.unHighLight()
            nowHighlightedSector?.highLight()
            self.highlightedSectorView = nowHighlightedSector

            self.delegate?.higlightedKidChanged(nuKidId: self.highlightedSectorView?.kidID, angleSpeed: currentAngleSpeed)
        }
    }

    private func stopAnimation() {
        guard let displayLink = self.displayLink else {
            //print("Not stopping animation: No display link")
            return
        }

        displayLink.remove(from: .current, forMode: .defaultRunLoopMode)
        self.displayLink = nil
    }

    private func startAnimation() {
        guard self.displayLink==nil else {
            print("NOT starting animation: There's still a display link")
            return
        }

        self.displayLink = CADisplayLink(target: self, selector:#selector(animationStep))
        if let displayLink=self.displayLink {
            displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        }
    }

    func animationStep(displayLink: CADisplayLink){
        let stepRadians = currentAngleSpeed * displayLink.duration
        currentAngleSpeed *= SLOW_DOWN_FACTOR

        self.updateCurrentRadians(currentRadians + CGFloat(stepRadians))

        self.transform = CGAffineTransform(rotationAngle: currentRadians)

        if abs(currentAngleSpeed) < STOP_SPEED {
            stopAndPick()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.spinHistory.clear()
        stopAnimation()
    }

    private func stopAndPick() {
        stopAnimation()

        if self.delegate != nil {
            if let highlightView = self.highlightedSectorView {
                self.delegate!.kidPicked(withId: highlightView.kidID)
            } else {
                print("NO selected view. Error.")
            }
        }
    }

    // interaction
    // //////////////////////////////////////////////////////////////////

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let groupId=kidsGroupId, let group = Core.instance.group(withId: groupId) else {
            print("KidGroup with id \(kidsGroupId) not found")
            return
        }

        // there can be no transform while adding sub-views and accessing the frame
        let transform = self.transform
        self.transform = CGAffineTransform.identity

        let width = self.frame.size.width
        let height = self.frame.size.width
        let radius = Float(width/2)

        self.layer.cornerRadius = width / 2

        let overallWeight = Float(group.getOverallWeight())

        var startRadians:Float = 0

        let sortedKeys = group.kids
        for kidId in sortedKeys {
            let kidWeight = Float(group.weightForKid(withId: kidId))
            let radianSpan = (kidWeight / overallWeight) * 2 * Float.pi

            guard let sectorView = sectorViews[kidId] else {
                print("no sector view yet for \(kidId)")
                continue
            }

            sectorView.transform = CGAffineTransform(rotationAngle:0)
            sectorView.updateRadianSpan(radius, radianSpan)
            sectorView.layer.anchorPoint = CGPoint(x:0, y:0.5)
            sectorView.layer.position = CGPoint(x:width/2, y:height/2)

            sectorView.updateTargetRadians(startRadians + radianSpan/2)

            startRadians += radianSpan
        }

        if (sectorViews.count > 0 && abs( startRadians - (2 * Float.pi) ) > 0.001){
            print("THIS DID NOT GO ACCORDING TO PLAN!")
        }

        // re-apply the current transform
        self.transform = transform
    }

    func update(withGroup group : KidsGroup) {
        self.kidsGroupId = group.id
        var notFoundKidIds = Set<String>(sectorViews.keys)

        for kidId in group.kids {
            notFoundKidIds.remove(kidId)

            guard let kid = Core.instance.kid(withId: kidId) else {
                print("Missing kid with id \(kidId)! This is an error.")
                continue
            }

            var foundView = sectorViews[kidId]
            if (foundView == nil){
                // no view yet for this kid. Add one!
                foundView = createSectorView(forKid: kid)
                self.addSubview(foundView!)
                sectorViews[kidId] = foundView
            }
        }

        // remove no longer needed views, collected in 'notFoundKidIds'
        for unusedViewId in notFoundKidIds {
            let removingView = sectorViews.removeValue(forKey: unusedViewId)!
            // TODO: animate away!
            removingView.removeFromSuperview()
        }

        // adapt sector views to new weight
        self.setNeedsLayout()
        // update selection
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.recomputeHighlightedKid()
        })

        self.updateCurrentRadians(self.currentRadians)
    }

    private func getSortedSectorViewKeys() -> [String] {
        return sectorViews.keys.elements.sorted { (keyA, keyB) -> Bool in
            let kidAOptional = Core.instance.kid(withId: keyA)
            let kidBOptional = Core.instance.kid(withId: keyB)

            guard let kidA = kidAOptional else {
                print("Kid with key \(keyA) missing!")
                return false
            }
            guard let kidB = kidBOptional else {
                print("Kid with key \(keyB) missing!")
                return false
            }

            return kidA.name.localizedCaseInsensitiveCompare(kidB.name) == .orderedAscending
        }
    }

    private func createSectorView(forKid kid: Kid) -> SectorView {
        let nuKidSector = SectorView(frame: CGRect(x:0, y:0, width:200,height:40))     // random rect. Will be re-layouted soon.
        nuKidSector.setToSmallMode(smallMode: smallMode)
        nuKidSector.showKid(kid)
        return nuKidSector
    }
}


/// a helper class to weed out slow rotations and not make them into spins
class SpinHistory {
    /// The fling turning will only be started when the starting angle speed is higher
    /// than this
    let MIN_FLING_SPEED = 0.3

    /// How much history we preserver
    let HISTORY_TIME : TimeInterval = 1

    /// Aggregate over this time to see if this might be slow spin (dialing to a specific position)
    let SLOW_SPIN_CHECK_TIME : TimeInterval = 0.4


    var history = [SpinHistoryEntry]()

    func addEntry(_ currentRadians : CGFloat){
        let now = Date()
        history.append(SpinHistoryEntry(timestamp: now, radians: currentRadians))

        while now.timeIntervalSince(history.first!.timestamp) > HISTORY_TIME {
            history.removeFirst()
        }
    }

    func clear() {
        history.removeAll()
    }

    func getAngleSpeed() -> Double {
        guard history.count > 1 else {
            return 0
        }

        let last = history.last!
        let beforeLast = history[history.count-2]

        let angleDelta = last.radians - beforeLast.radians
        let timeDelta = last.timestamp.timeIntervalSince(beforeLast.timestamp)

        return Double(angleDelta) / timeDelta
    }

    func shouldSpin() -> Bool {
        guard history.count > 1 else {
            print("Not enough history. Not spinning.")
            return false
        }

        var lastEntry = history.last!
        let latestEventDate = lastEntry.timestamp

        let relevantHistory = self.history.filter { entry in
            latestEventDate.timeIntervalSince(entry.timestamp) < SLOW_SPIN_CHECK_TIME
        }.reversed()

        var radiansCollector : CGFloat = 0
        for entry:SpinHistoryEntry in relevantHistory {
            radiansCollector += (entry.radians - lastEntry.radians)
            lastEntry = entry
        }

        let checkedHistoryTime = relevantHistory.first!.timestamp.timeIntervalSince(relevantHistory.last!.timestamp);

        return abs(Double(radiansCollector)/checkedHistoryTime) > MIN_FLING_SPEED
    }
}

struct SpinHistoryEntry {
    let timestamp : Date;
    let radians : CGFloat;
}
