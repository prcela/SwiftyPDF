//
//  TiledDelegate.swift
//  SwiftyPDF
//
//  Created by prcela on 14/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class TiledDelegate: NSObject
{
    var page: CGPDFPage
    init(page: CGPDFPage)
    {
        self.page = page
    }

    func drawLayer(_ layer: CALayer, inContext ctx: CGContext)
    {
        let pageRect:CGRect = page.getBoxRect(Config.pdfBox)
//        let pdfScale:CGFloat = width/pageRect.size.width
//        pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale)
//        pageRect.origin = CGPointZero
        
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: pageRect.size.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.concatenate(page.getDrawingTransform(Config.pdfBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
        

        ctx.drawPDFPage(page)
        ctx.restoreGState()
    }

}
