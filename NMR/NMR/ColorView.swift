//
//  NMRImageView.swift
//  NMR
//
//  Created by David Falk on 20/06/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import UIKit

@IBDesignable
class ColorView: UIView {
    @IBInspectable
    var lineWidth: CGFloat = 2 { didSet { setNeedsDisplay() } }
    var dataProvider: HighlightDataProvider!
    
    private var paths = [
        UIBezierPath(rect: CGRect(x: 5, y: 10, width: 63, height: 98)),
        UIBezierPath(rect: CGRect(x: 128, y: 42, width: 27, height: 95)),
        UIBezierPath(rect: CGRect(x: 163, y: 42, width: 62, height: 95))
    ]
 
    override func drawRect(rect: CGRect) {
        let framePath = UIBezierPath(rect: bounds)
        framePath.lineWidth = 2
        NSUIColor.grayColor().set()
        framePath.stroke()
        
        for (index, path) in paths.enumerate() {
            if dataProvider.isHighlighted(atIndex: index) {
                dataProvider.highlightColor(index).set()
                path.lineWidth = lineWidth
                path.stroke()
            }
        }
    }
}