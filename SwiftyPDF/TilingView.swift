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
    
    override class var layerClass : AnyClass
    {
        return CATiledLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
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
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let tileSize = Config.tileSize
        
        let firstCol = Int(floor(rect.minX / tileSize.width))
        let lastCol = Int(floor((rect.maxX-1) / tileSize.width))
        let firstRow = Int(floor(rect.minY / tileSize.height))
        let lastRow = Int(floor((rect.maxY-1) / tileSize.height))
        
        for row in firstRow..<lastRow + 1 {
            for col in firstCol..<lastCol + 1 {
                var tileRect = CGRect(x: tileSize.width * CGFloat(col), y: tileSize.height * CGFloat(row),
                    width: tileSize.width, height: tileSize.height)
                
                if rect.intersection(tileRect) != CGRect.null
                {
                    if let tile = tileAt(col, row)
                    {
                        tileRect = bounds.intersection(tileRect)
                        
                        tile.draw(in: tileRect)
                        
                        if Config.showTileLines
                        {
                            let bpath = UIBezierPath(rect: tileRect)
                            UIColor.gray.set()
                            bpath.stroke()
                        }
                    }
                }
            }
        }

    }

    func tileAt(_ col: Int, _ row: Int) -> UIImage?
    {
        let cachedTilesPath = ImageCreator.cachedTilesPath(pageIdx)
        
        let path = "\(cachedTilesPath)/\(col)_\(row).png"
        if FileManager.default.fileExists(atPath: path)
        {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }

}
