//
//  CoreDataModel.swift
//  NMR
//
//  Created by David Falk on 23/06/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataModel {
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    init?() {
        guard let highlights = highlights
            else { return nil }
        if highlights.count == 0 {
            for index in 0...2 {
                let highlight = NSEntityDescription.insertNewObjectForEntityForName("Highlight",
                                                            inManagedObjectContext: delegate.managedObjectContext) as! Highlight
                highlight.index = index
                highlight.active = false
            }
            self.highlights = nil
        }
        guard let dataPoints = dataPoints
            else { return nil }
        
        if dataPoints.count == 0 {
            let file = NSBundle.mainBundle().pathForResource("Data", ofType: "csv")
            let data = try! CSV(name: file!)
            let (x, y) = (data.header[0], data.header[1])
            for (index, row) in data.rows.enumerate() {
                guard index % 3 == 0
                    else { continue }
                let dataPoint = NSEntityDescription.insertNewObjectForEntityForName("DataPoint",
                                                            inManagedObjectContext: delegate.managedObjectContext) as! DataPoint
                dataPoint.x = NSNumber(double: Double(row[x]!)!)
                dataPoint.y = NSNumber(double: Double(row[y]!)!)
            }
            self.dataPoints = nil
        }
    }
    private var _highlights: [Highlight]? = nil
    private(set) var highlights: [Highlight]? {
        get {
            if _highlights != nil {
                return _highlights
            }
            let fetchHighlights = NSFetchRequest(entityName: "Highlight")
            fetchHighlights.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
            guard let highlights = try? delegate.managedObjectContext.executeFetchRequest(fetchHighlights) as? [Highlight]
                else { return nil }
            _highlights = highlights
            return _highlights
        }
        set {
            delegate.saveContext()
            _highlights = newValue
        }
    }
    
    private var _dataPoints: [DataPoint]? = nil
    private(set) var dataPoints: [DataPoint]? {
        get {
            if _dataPoints != nil {
                return _dataPoints
            }
            let requestDataPoints = NSFetchRequest(entityName: "DataPoint")
            requestDataPoints.sortDescriptors = [NSSortDescriptor(key: "x", ascending: false)]
            guard let dataPoints = try? delegate.managedObjectContext.executeFetchRequest(requestDataPoints) as? [DataPoint]
                else { return nil }
            return dataPoints
        }
        set {
            delegate.saveContext()
            _dataPoints = newValue
        }
    }

}