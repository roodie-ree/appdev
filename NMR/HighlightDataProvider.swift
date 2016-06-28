//
//  HighlightDataProvider.swift
//  NMR
//
//  Created by David Falk on 21/06/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import UIKit

protocol HighlightDataProvider: class {
    func isHighlighted(atIndex index: Int) -> Bool
    func highlightColor(index: Int) -> NSUIColor
    func highlightFromBarIndex(index: Int) -> Int?
}