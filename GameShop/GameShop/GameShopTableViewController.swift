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
    
    var games: [Game] = []

    override init(style: UITableViewStyle) {
        super.init(style: style)
        loadModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadModel()
    }
    
    func loadModel() {
        if let games = Game.initFromPropertyList() {
            self.games = games
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    override func numberOfSectionsInTableView(tv: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tv: UITableView, numberOfRowsInSection:  Int) -> Int {
        if numberOfRowsInSection == 0 {
            return games.count
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
    
    override func tableView(tv: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tv.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == UITableViewCellAccessoryType.None {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            tv.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func coverArtForGameTableViewCell(sender: GameTableViewCell) -> UIImage? {
        let file = games[sender.indexPath.row].cover.componentsSeparatedByString(".")
        if let path = NSBundle.mainBundle().pathForResource(file[0], ofType: file[1]) {
            return UIImage(contentsOfFile: path)
        } else {
            return nil
        }
    }
    
    func gameNameForGameTableViewCell(sender: GameTableViewCell) -> String? {
        return games[sender.indexPath.row].title
    }
    
    func gamePlatformForGameTableViewCell(sender: GameTableViewCell) -> String? {
        return games[sender.indexPath.row].system
    }
    
    func gamePriceForGameTableViewCell(sender: GameTableViewCell) -> String? {
        return games[sender.indexPath.row].price
    }
    
}