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

    override func drawLayer(layer: CALayer, inContext ctx: CGContext)
    {
        let pageRect:CGRect = CGPDFPageGetBoxRect(page, Config.pdfBox)
//        let pdfScale:CGFloat = width/pageRect.size.width
//        pageRect.size = CGSizeMake(pageRect.size.width*pdfScale, pageRect.size.height*pdfScale)
//        pageRect.origin = CGPointZero
        
        CGContextSaveGState(ctx)
        CGContextTranslateCTM(ctx, 0.0, pageRect.size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)
        CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(page, Config.pdfBox, pageRect, 0, true))
        

        CGContextDrawPDFPage(ctx, page)
        CGContextRestoreGState(ctx)
    }

}
