//
// Created by Matthias Schicker on 07/02/2017.
// Copyright (c) 2017 Matthias Schicker. All rights reserved.
//

import UIKit

func randomFloat(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
    return min + ((CGFloat(arc4random() % 10000) / 10000.0) * (max - min))
}

func randomFloat() -> CGFloat {
    return randomFloat(0, 1);
}

func isIn(_ toCheck: CGFloat, minIncl: CGFloat, maxExcl: CGFloat) -> Bool {
    return toCheck >= minIncl && toCheck < maxExcl;
}

infix operator ><: ComparisonPrecedence

func ><(toCheck: CGFloat, inIncl: (CGFloat, CGFloat)) -> Bool {
    return (toCheck >= inIncl.0) && (toCheck <= inIncl.1);
}

func ><(toCheck: Float, inIncl: (Float, Float)) -> Bool {
    return (toCheck >= inIncl.0) && (toCheck <= inIncl.1);
}

func clipToUnitCircle(angle: CGFloat) -> CGFloat {
    if angle < 0 {
        return angle + 2 * CGFloat.pi
    } else if angle > 2 * CGFloat.pi {
        return angle - 2 * CGFloat.pi
    }
    return angle
}

func clipToUnitCircle(angle: Float) -> Float {
    if angle < 0 {
        return angle + 2 * Float.pi
    } else if angle > 2 * Float.pi {
        return angle - 2 * Float.pi
    }
    return angle
}

extension UIColor {
    class func randomColor() -> UIColor {
        return UIColor(hue: randomFloat(), saturation: randomFloat(0.8, 1), brightness: randomFloat(0.75, 1), alpha: 1)
    }

    func lightened() -> UIColor {
        let ret = self.adjust(by: 10)
        return ret == nil ? self : ret!
    }

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0

        if (self.getRed(&r, green: &g, blue: &b, alpha: &a)) {
            return UIColor(red: min(r + percentage / 100, 1.0),
                    green: min(g + percentage / 100, 1.0),
                    blue: min(b + percentage / 100, 1.0),
                    alpha: a)
        } else {
            return nil
        }
    }
}
