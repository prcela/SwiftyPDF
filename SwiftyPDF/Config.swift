//
//  Config.swift
//  SwiftyPDF
//
//  Created by prcela on 18/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

struct Config
{
    // defines the actual content size of scroll view. It is equal to real pdf size * pdf size magnifier
    static let contentSizeMagnifier:CGFloat = 2
    
    // extra zoom allows to go beyond content size
    static let extraZoom: CGFloat = 1
    
    // size of tile 
    static let tileSize = CGSize(width: 256, height: 256)
    
    // show tiles grid
    static let showTileLines = true
}
