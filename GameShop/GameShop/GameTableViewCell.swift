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
    
    /*override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }*/
    
    weak var dataSource: GameTableViewCellDataSource? {
        didSet {
            gameCoverArt.image = dataSource?.coverArtForGameTableViewCell(self)
            //gameCoverArt = UIImageView(image: dataSource?.coverArtForGameTableViewCell(self))
            //gameName = UILabel()
            gameName.text = dataSource?.gameNameForGameTableViewCell(self)
            //gamePlatform = UILabel()
            gamePlatform.text = dataSource?.gamePlatformForGameTableViewCell(self)
            //gamePrice = UILabel()
            gamePrice.text = dataSource?.gamePriceForGameTableViewCell(self)
            if gamePrice.text != nil {
                gamePrice.text! += " €"
            }
        }
    }
    var indexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
}