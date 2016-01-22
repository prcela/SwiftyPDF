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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        if let tiledLayer = layer as? CATiledLayer
        {
            tiledLayer.tileSize = Config.tileSize
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let tileSize = Config.tileSize
        
        let firstCol = Int(floor(CGRectGetMinX(rect) / tileSize.width))
        let lastCol = Int(floor((CGRectGetMaxX(rect)-1) / tileSize.width))
        let firstRow = Int(floor(CGRectGetMinY(rect) / tileSize.height))
        let lastRow = Int(floor((CGRectGetMaxY(rect)-1) / tileSize.height))
        
        for (var row = firstRow; row <= lastRow; row++)
        {
            for (var col = firstCol; col <= lastCol; col++)
            {
                var tileRect = CGRectMake(tileSize.width * CGFloat(col), tileSize.height * CGFloat(row),
                    tileSize.width, tileSize.height)
                
                if CGRectIntersection(rect, tileRect) != CGRectNull
                {
                    if let tile = tileAt(col, row)
                    {
                        tileRect = CGRectIntersection(bounds, tileRect)
                        
                        tile.drawInRect(tileRect)
                        
                        if Config.showTileLines
                        {
                            let bpath = UIBezierPath(rect: tileRect)
                            UIColor.grayColor().set()
                            bpath.stroke()
                        }
                    }
                }
            }
        }

    }

    func tileAt(col: Int, _ row: Int) -> UIImage?
    {
        let cachedPagesPath = ImageCreator.cachedPagesPath()
        
        let path = "\(cachedPagesPath)/\(pageIdx)/\(col)_\(row).png"
        if NSFileManager.defaultManager().fileExistsAtPath(path)
        {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }

}
