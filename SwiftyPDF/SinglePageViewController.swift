//
//  SinglePageViewController.swift
//  SwiftyPDF
//
//  Created by prcela on 14/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class SinglePageViewController: UIViewController {
    
    @IBOutlet weak var imageScrollView: ImageScrollView?
    
    weak var pageDesc: PdfPageDesc? {
        didSet {
            pageDesc?.createTiles()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView?.layoutIfNeeded()
        
        displayZoomImage()
    }
    
    func displayZoomImage()
    {
        if let placeholder = pageDesc?.placeholder
        {
            let scale = Config.pdfSizeMagnifier * UIScreen.mainScreen().scale
            let imageContentSize = CGSize(width: scale*placeholder.size.width, height: scale*placeholder.size.height)
            imageScrollView?.displayZoomImage(placeholder, imageContentSize: imageContentSize)
        }
    }
    
    
    func displayTiledImages()
    {
        imageScrollView?.displayTiledImage(CGPDFPageGetPageNumber(pageDesc!.pdfPage))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SinglePageViewController: UIScrollViewDelegate
{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageScrollView!.zoomImageView
    }
}
