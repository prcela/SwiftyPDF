//
//  PdfPageToImageOperation.swift
//  SwiftyPDF
//
//  Created by prcela on 15/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class PdfPageToImageOperation: Operation
{
    var imageSize: CGSize
    var pageIdx: Int
    var completion: ((_ success: Bool, _ image: UIImage)->Void)? = nil
    
    init(imageSize: CGSize, pageIdx: Int)
    {
        self.imageSize = imageSize
        self.pageIdx = pageIdx
        
        super.init()
    }
    
    override func main()
    {
        let width:CGFloat = imageSize.width
        let pdfPage = PdfDocument.getPage(pageIdx)!
        var pageRect:CGRect = pdfPage.getBoxRect(Config.pdfBox)
        let pdfScale:CGFloat = width/pageRect.size.width
        pageRect.size = CGSize(width: pageRect.size.width*pdfScale, height: pageRect.size.height*pdfScale)
        pageRect.origin = CGPoint.zero
        
        UIGraphicsBeginImageContext(pageRect.size)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        // White BG
        context.setFillColor(red: 1.0,green: 1.0,blue: 1.0,alpha: 1.0)
        context.fill(pageRect)
        
        
        
        // ***********
        // Next 3 lines makes the rotations so that the page look in the right direction
        // ***********
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.saveGState()
        
//        CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(pdfPage, CGPDFBox.CropBox, pageRect, 0, true))
        context.scaleBy(x: pdfScale, y: pdfScale)
        
        context.interpolationQuality = .high
        context.setRenderingIntent(.defaultIntent)
        
        context.drawPDFPage(pdfPage)
        context.restoreGState()
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        DispatchQueue.main.async {
            self.completion?(true, img)
        }


    }

}
