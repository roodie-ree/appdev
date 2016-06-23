//
//  Highlight+CoreDataProperties.swift
//  NMR
//
//  Created by David Falk on 21/06/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Highlight {

    @NSManaged var active: NSNumber?
    @NSManaged var index: NSNumber?
}
