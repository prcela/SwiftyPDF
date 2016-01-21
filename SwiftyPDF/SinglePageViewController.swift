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

    var pageIdx: Int?
//        {
//        didSet {
//            let pdfDesc = PdfDocument.getPageDesc(pageIdx!)!
//            if !pdfDesc.placeholderExists()
//            {
//                pdfDesc.createPlaceHolder(view.bounds.size) { success in
//                    if self.isViewLoaded()
//                    {
//                        self.displayZoomImage()
//                    }
//                }
//            }
//            pdfDesc.createTiles()
//        }
//    }
    
    deinit {
        print("deinit single page at index \(pageIdx)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView?.layoutIfNeeded()
        
        let pdfDesc = PdfDocument.getPageDesc(pageIdx!)!
        
        if pdfDesc.placeholderExists()
        {
            displayZoomImage()
        }
        else
        {
            pdfDesc.createPlaceHolder(view.bounds.size) { success in
                self.displayZoomImage()
            }
        }

        pdfDesc.createTiles()
    }
    
    func displayZoomImage()
    {
        let path = "\(ImageCreator.cachedPagesPath())/\(pageIdx!)/placeholder.png"
        if NSFileManager.defaultManager().fileExistsAtPath(path)
        {
            let placeholder = UIImage(contentsOfFile: path)!
            let pdfPage = PdfDocument.getPage(pageIdx!)!
            let pdfPageSize = CGPDFPageGetBoxRect(pdfPage, Config.pdfBox).size
            let scale = Config.pdfSizeMagnifier //* UIScreen.mainScreen().scale
            let imageContentSize = CGSize(width: scale*pdfPageSize.width, height: scale*pdfPageSize.height)
            imageScrollView?.displayZoomImage(placeholder, imageContentSize: imageContentSize)
        }
    }
    
    
    func displayTiledImages()
    {
        imageScrollView?.displayTiledImages(pageIdx!)
    }
    
    func removeTilingView()
    {
        imageScrollView?.tilingView?.removeFromSuperview()
        imageScrollView?.tilingView = nil
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
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat)
    {
        print("Did end zooming at scale \(scale)")
        if scale > scrollView.minimumZoomScale + Config.minScaleToleranceForTiling
        {
            displayTiledImages()
        }
        else
        {
            removeTilingView()
        }
    }
}
