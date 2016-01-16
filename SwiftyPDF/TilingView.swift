//
//  TilingView.swift
//  SwiftyPDF
//
//  Created by prcela on 16/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class TilingView: UIView
{
    
    var pageIdx: Int!
    
    override class func layerClass() -> AnyClass
    {
        return CATiledLayer.self
    }
    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let tileSize = CGSize(width: 256, height: 256)
        
        let firstCol = Int(floor(CGRectGetMinX(rect) / tileSize.width))
        let lastCol = Int(floor((CGRectGetMaxX(rect)-1) / tileSize.width))
        let firstRow = Int(floor(CGRectGetMinY(rect) / tileSize.height))
        let lastRow = Int(floor((CGRectGetMaxY(rect)-1) / tileSize.height))
        
        for (var row = firstRow; row <= lastRow; row++) {
            for (var col = firstCol; col <= lastCol; col++) {
                if let tile = tileAtCol(col, row:row)
                {
                    var tileRect = CGRectMake(tileSize.width * CGFloat(col), tileSize.height * CGFloat(row),
                        tileSize.width, tileSize.height)
                    
                    tileRect = CGRectIntersection(bounds, tileRect)
                    
                    tile.drawInRect(tileRect)
                    
                    //        [[UIColor whiteColor] set];
                    //        CGContextSetLineWidth(context, 6.0);
                    //        CGContextStrokeRect(context, tileRect);
                }
            }
        }

    }

    func tileAtCol(col: Int, row: Int) -> UIImage?
    {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let cacheDirPath = paths.first!
        
        let path = "\(cacheDirPath)/\(pageIdx)/\(col)_\(row).png"
        return UIImage(contentsOfFile: path)
    }

}