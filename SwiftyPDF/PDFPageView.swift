//
//  PDFPageView.swift
//  SwiftyPDF
//
//  Created by prcela on 14/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class PDFPageView: UIView
{
    var zoom: CGFloat = 0.5
    var tiledLayer = CATiledLayer()

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // configure the layers
    override func awakeFromNib() {

        // set up this view & its layer
        
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        layer.backgroundColor = UIColor.white.cgColor
        
    }
    
    func setup()
    {
        let tiledDelegate = tiledLayer.delegate as! TiledDelegate
        let pageRect = tiledDelegate.page.getBoxRect(Config.pdfBox)

        var w = Int(pageRect.size.width)
        var h = Int(pageRect.size.height)
        // get level count
        var levels = 1
        while (w > 1 && h > 1) {
            levels += 1;
            w = w >> 1;
            h = h >> 1;
        }
        // set the levels of detail
        tiledLayer.levelsOfDetail = levels
        // set the bias for how many 'zoom in' levels there are
        tiledLayer.levelsOfDetailBias = 4;
//        tiledLayer.tileSize = CGSize(width: 512, height: 512)
        // setup the size and position of the tiled layer
        zoom = frame.size.width/pageRect.width
        tiledLayer.bounds = CGRect(x: 0.0, y: 0.0,
            width: pageRect.width,
            height: pageRect.height);
        let x = tiledLayer.bounds.width * tiledLayer.anchorPoint.x;
        let y = tiledLayer.bounds.height * tiledLayer.anchorPoint.y;
        tiledLayer.position = CGPoint(x: x * zoom, y: y * zoom);
        tiledLayer.transform = CATransform3DMakeScale(zoom, zoom, 1.0);
        
        layer.addSublayer(tiledLayer)
        
        tiledLayer.setNeedsDisplay()

    }


}
