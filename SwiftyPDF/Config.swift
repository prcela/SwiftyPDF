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
    // defines the actual content size of scroll view. contentSize = (real pdf size) x (pdf size magnifier) * (screen scale)
    static let pdfSizeMagnifier:CGFloat = 1
    
    // extra zoom allows to go beyond content size
    static let extraZoom: CGFloat = 1
    
    // size of tile 
    static let tileSize = CGSize(width: 256, height: 256)
    
    // show tiles grid (for developing purpose to see when tile is actualy drawn)
    static let showTileLines = true
}