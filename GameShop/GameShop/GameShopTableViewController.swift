//
//  GameShopTableViewController.swift
//  GameShop
//
//  Created by David Falk on 11/05/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import Foundation
import UIKit

protocol GameTableViewCellDataSource: class {
    func coverArtForGameTableViewCell(sender: GameTableViewCell) -> UIImage?
    func gameNameForGameTableViewCell(sender: GameTableViewCell) -> String?
    func gamePlatformForGameTableViewCell(sender: GameTableViewCell) -> String?
    func gamePriceForGameTableViewCell(sender: GameTableViewCell) -> String?
}

class GameShopTableViewController: UITableViewController, GameTableViewCellDataSource {
    
    var GameCoverArts: [String] = []
    var GameNames: [String] = []
    var GamePlatforms: [String] = []
    var GamePrices: [String] = []

    override init(style: UITableViewStyle) {
        super.init(style: style)
        loadModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadModel()
    }
    
    func loadModel() {
        if let path = NSBundle.mainBundle().pathForResource("Data", ofType: "plist", inDirectory: "/") {
            if let data = NSDictionary(contentsOfFile: path) as? [String: [String]] {
                if let cover = data["Cover"] {
                    if let name = data["GameName"] {
                        if let system = data["System"] {
                            if let price = data["Price"] {
                                GameCoverArts = cover
                                GameNames = name
                                GamePlatforms = system
                                GamePrices = price
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tv: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tv: UITableView, numberOfRowsInSection:  Int) -> Int {
        if numberOfRowsInSection == 0 {
            return GameNames.count
        } else {
            return 0
        }
    }
    
    override func tableView(tv: UITableView, heightForRowAtIndexPath:  NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(tv: UITableView, cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        let dequeue = tv.dequeueReusableCellWithIdentifier("gameTableCell", forIndexPath: indexPath)
        let cell = dequeue as! GameTableViewCell
        cell.indexPath = indexPath
        cell.dataSource = self
        return cell
    }
    
    func coverArtForGameTableViewCell(sender: GameTableViewCell) -> UIImage? {
        let file = GameCoverArts[sender.indexPath.row].componentsSeparatedByString(".")
        if let path = NSBundle.mainBundle().pathForResource(file[0], ofType: file[1]) {
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }
    
    func gameNameForGameTableViewCell(sender: GameTableViewCell) -> String? {
        return GameNames[sender.indexPath.row]
    }
    
    func gamePlatformForGameTableViewCell(sender: GameTableViewCell) -> String? {
        return GamePlatforms[sender.indexPath.row]
    }
    
    func gamePriceForGameTableViewCell(sender: GameTableViewCell) -> String? {
        return GamePrices[sender.indexPath.row]
    }
    
}