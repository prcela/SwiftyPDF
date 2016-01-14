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
        CGContextDrawPDFPage(ctx, page)
    }

}
