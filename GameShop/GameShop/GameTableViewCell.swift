//
//  GameTableViewCell.swift
//  GameShop
//
//  Created by David Falk on 11/05/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import Foundation
import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet var gameCoverArt: UIImageView!
    @IBOutlet var gameName: UILabel!
    @IBOutlet var gamePlatform: UILabel!
    @IBOutlet var gamePrice: UILabel!
    
    weak var dataSource: GameTableViewCellDataSource? {
        didSet {
            gameCoverArt.image = dataSource?.coverArtForGameTableViewCell(self)
            gameName.text = dataSource?.gameNameForGameTableViewCell(self)
            gamePlatform.text = dataSource?.gamePlatformForGameTableViewCell(self)
            gamePrice.text = dataSource?.gamePriceForGameTableViewCell(self)
            if gamePrice.text != nil {
                gamePrice.text! += " €"
            }
        }
    }
    var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
}