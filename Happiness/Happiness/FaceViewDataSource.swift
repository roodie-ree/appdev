//
//  FaceViewDataSource.swift
//  Happiness
//
//  Created by David Falk on 21/04/16.
//  Copyright © 2016 Hochschule Darmstadt. All rights reserved.
//

import Foundation
protocol FaceViewDataSource: class {
    func happinessForFaceView(sender: FaceView) -> Double?
}