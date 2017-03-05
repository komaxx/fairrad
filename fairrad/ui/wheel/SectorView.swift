//
// Created by Matthias Schicker on 01/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import UIKit


class SectorView : UIView {
    let INNER_RADIUS_FACTOR : Float = 0.3

    var kidNameLabel: UILabel!
    var kidImageView: UIImageView!

    var kidID : String?

    var targetRadians : Float = 0
    var radianSpan = Float.pi
    var radius : Float = 200

    var path : UIBezierPath?

    var backgroundLayer: QuartzCore.CAShapeLayer!
    var highlightLayer: QuartzCore.CAShapeLayer!
    var maskLayer: QuartzCore.CAShapeLayer!

    var smallMode = false

    var highlighted : Bool = false


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.kidNameLabel.sizeToFit()
        self.kidNameLabel.frame = CGRect(
                x:bounds.width-self.kidNameLabel.frame.width - 15,
                y:(self.bounds.height-self.kidNameLabel.frame.height)/2,
                width: self.kidNameLabel.frame.width, height: self.kidNameLabel.frame.height)
    }

    func setToSmallMode(smallMode : Bool){
        self.smallMode = smallMode
        self.kidNameLabel.isHidden = smallMode
    }

    private func setup() {
        if (self.layer.mask != nil){
            print("There was already a mask??")
        }

        backgroundLayer = QuartzCore.CAShapeLayer()
        highlightLayer = QuartzCore.CAShapeLayer()
        maskLayer = QuartzCore.CAShapeLayer()

        self.layer.insertSublayer(backgroundLayer, at: 0)
        backgroundLayer.fillColor = UIColor.randomColor().cgColor

        self.layer.insertSublayer(highlightLayer, at: 1)
        highlightLayer.fillColor = nil
        highlightLayer.strokeColor = UIColor.yellow.cgColor
        highlightLayer.lineWidth = 3
        self.highlightLayer.isHidden = true

        self.kidNameLabel = UILabel(frame:CGRect(x: 0, y: 0, width: 200, height: 10))
        self.kidNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.kidNameLabel.font = UIFont.systemFont(ofSize: 16)
        self.kidNameLabel.shadowColor = UIColor(white: 0.3, alpha: 0.4)
        self.kidNameLabel.shadowOffset = CGSize(width: 0, height: 2)
        self.addSubview(self.kidNameLabel)
    }

    func updateRadianSpan(_ radius: Float, _ radians: Float) {
        self.radianSpan = radians;
        self.radius = radius;

        let sine = sin(radians/2)

        var halfHeight = radius * sine;
        if radians > Float.pi {
            halfHeight = radius
        }

        self.frame = CGRect(x:0, y:0, width: Int(radius), height: Int(halfHeight*2))

        let innerRadius = radius * INNER_RADIUS_FACTOR
        let path = UIBezierPath();
        path.addArc(
                withCenter: CGPoint(x:CGFloat(0), y:CGFloat(halfHeight)),
                radius:CGFloat(innerRadius),
                startAngle: CGFloat(radians/2.0),
                endAngle: CGFloat(-radians/2),
                clockwise: false)

        path.addArc(
                withCenter: CGPoint(x:CGFloat(0), y:CGFloat(halfHeight)),
                radius:CGFloat(radius),
                startAngle: CGFloat(-radians/2.0),
                endAngle: CGFloat(radians/2),
                clockwise: true)

        path.close()

        self.backgroundLayer.path = path.cgPath;
        self.highlightLayer.path = path.cgPath;

        // only show the label when the slice is not too narrow
        kidNameLabel.isHidden = smallMode || CGFloat(halfHeight) < kidNameLabel.bounds.size.height;

        // TODO: decide whether clipping is necessary or not (only for the last drawn
        // TODO: sector and then only when the content does not fit in the bounds)
//        self.maskLayer.path = path.cgPath
//        if false {
//            self.layer.mask = maskLayer
//        }
    }

    func updateTargetRadians(_ targetRadians: Float){
        updateTransform(animationSpeed: -1)
        self.targetRadians = targetRadians;
        updateTransform(animationSpeed: 0.25)
    }

    func showKid(_ kid: Kid) {
        self.kidID = kid.id
        self.kidNameLabel.text = kid.name
        self.backgroundLayer.fillColor = kid.color.cgColor

        self.setNeedsLayout()
    }

    private func updateTransform(animationSpeed: Double) {
        // update position

        var targetTransform = CGAffineTransform(rotationAngle:CGFloat(self.targetRadians));
        if (self.highlighted){
            targetTransform = CGAffineTransform(scaleX: 1.01, y: 1.01).concatenating(targetTransform)
        }

        let options = UIViewAnimationOptions([UIViewAnimationOptions.curveEaseOut])

        if (animationSpeed > 0){
            UIView.animate(withDuration: animationSpeed, delay: 0, options:options, animations: {
                self.transform = targetTransform
            }, completion: nil)
        } else {
            self.transform = targetTransform
        }
    }

    func highLight() {
        self.highlighted = true
        self.highlightLayer.isHidden = false
        updateTransform(animationSpeed: 0.2)
    }

    func unHighLight() {
        self.highlighted = false
        self.highlightLayer.isHidden = true
        updateTransform(animationSpeed: 0.05)
    }
}
