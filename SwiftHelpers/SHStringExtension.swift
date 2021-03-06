//
//  StringExtension.swift
//  Boddy
//
//  Created by Remi Santos on 12/03/15.
//  Copyright (c) 2015 Wopata. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    public func replaceHTMLTag(tag: String, withAttributes attributes: [String: AnyObject]) -> NSAttributedString {
        let openTag = "<\(tag)>"
        let closeTag = "</\(tag)>"
        let resultingText: NSMutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        while true {
            let plainString = resultingText.string as NSString
            let openTagRange = plainString.rangeOfString(openTag)
            if openTagRange.length == 0 {
                break
            }
            
            let affectedLocation = openTagRange.location + openTagRange.length
            
            var searchRange = NSMakeRange(affectedLocation, plainString.length - affectedLocation)
            
            let closeTagRange = plainString.rangeOfString(closeTag, options: NSStringCompareOptions(0), range: searchRange)
            
            resultingText.setAttributes(attributes, range: NSMakeRange(affectedLocation, closeTagRange.location - affectedLocation))
            resultingText.deleteCharactersInRange(closeTagRange)
            resultingText.deleteCharactersInRange(openTagRange)
        }
        return resultingText as NSAttributedString
    }
}

public extension String {
    public var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    public func isNumeric() -> Bool {
        if let n = self.toInt() {
            return true
        } else {
            return false
        }
    }
    
    public func rangeString(string: String) -> NSRange {
        return NSString(string: self).rangeOfString(string)
    }
}

public extension String {
    
    public var CGColor: CGColorRef {
        return self.CGColor(1)
    }
    
    public var UIColor: UIKit.UIColor {
        return self.UIColor(1)
    }
    
    public func CGColor (alpha: CGFloat) -> CGColorRef {
        return self.UIColor(alpha).CGColor
    }
    
    public func UIColor (alpha: CGFloat) -> UIKit.UIColor {
        var hex = self
        
        if hex.hasPrefix("#") { // Strip leading "#" if it exists
            hex = hex.substringFromIndex(hex.startIndex.successor())
        }
        
        switch count(hex) {
        case 1: // Turn "f" into "ffffff"
            hex = hex.repeat(6)
        case 2: // Turn "ff" into "ffffff"
            hex = hex.repeat(3)
        case 3: // Turn "123" into "112233"
            hex = hex[0].repeat(2) + hex[1].repeat(2) + hex[2].repeat(2)
        default:
            break
        }
        
        assert(count(hex) == 6, "Invalid hex value")
        
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        
        NSScanner(string: "0x" + hex[0...1]).scanHexInt(&r)
        NSScanner(string: "0x" + hex[2...3]).scanHexInt(&g)
        NSScanner(string: "0x" + hex[4...5]).scanHexInt(&b)
        
        let red = CGFloat(Int(r)) / CGFloat(255.0)
        let green = CGFloat(Int(g)) / CGFloat(255.0)
        let blue = CGFloat(Int(b)) / CGFloat(255.0)
        
        return UIKit.UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

private extension String {
    
    func repeat (count: Int) -> String {
        return "".stringByPaddingToLength((self as NSString).length * count, withString: self, startingAtIndex:0)
    }
    
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}
