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
            pdfDesc.preparePlaceHolder(view.bounds.size) { success in
                self.displayZoomImage()
            }
        }

        pdfDesc.prepareTiles()
    }
    
    func displayZoomImage()
    {
        let path = "\(ImageCreator.cachedPagesPath())/\(pageIdx!)/placeholder.png"
        if FileManager.default.fileExists(atPath: path)
        {
            let placeholder = UIImage(contentsOfFile: path)!
            let pdfPageSize = PdfDocument.getPageSize(pageIdx!)
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
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageScrollView!.zoomImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
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
