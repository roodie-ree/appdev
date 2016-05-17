//
//  Game.swift
//  GameShop
//
//  Created by David Falk on 17/05/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import Foundation

class Game {
    private(set) var title, price, system, cover: String
    
    init(title: String, price: String, system: String, cover: String) {
        self.title = title
        self.price = price
        self.system = system
        self.cover = cover
    }
    
    class func initFromPropertyList() -> [Game]? {
        if let path = NSBundle.mainBundle().pathForResource("Data", ofType: "plist") {
            if let data = NSDictionary(contentsOfFile: path) as? [String: [String]] {
                if let cover = data["Cover"] {
                    if let name = data["GameName"] {
                        if let system = data["System"] {
                            if let price = data["Price"] {
                                if cover.count == name.count && system.count == price.count &&
                                    cover.count == system.count {
                                    return (0..<name.count).map { index in
                                        Game(title: name[index], price: price[index],
                                             system: system[index], cover: cover[index])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
}