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
    static let pdfSizeMagnifier:CGFloat = 2
    
    // extra zoom allows to go and bounce beyond content size
    static let bounceZoom: CGFloat = 1.1
    
    // size of tile 
    static let tileSize = CGSize(width: 512, height: 512)
    
    // show tiles grid (for developing purpose to see when tile is actualy drawn)
    static let showTileLines = true
    
    // pdf box
    static let pdfBox:CGPDFBox = .MediaBox
    
    // minimum zoom scale tolerance before tiling starts
    static let minScaleToleranceForTiling: CGFloat = 0.15
}