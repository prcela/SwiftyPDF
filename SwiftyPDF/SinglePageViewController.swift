//
//  SinglePageViewController.swift
//  SwiftyPDF
//
//  Created by prcela on 14/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class SinglePageViewController: UIViewController {

    var tiledDelegate: TiledDelegate!
    
    var pdfPageView: PDFPageView?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.layoutIfNeeded()

        // Do any additional setup after loading the view.
        pdfPageView = PDFPageView()
        let pageRect = CGPDFPageGetBoxRect(tiledDelegate.page, .CropBox)
        pdfPageView?.frame = pageRect
        scrollView.addSubview(pdfPageView!)
        
        print("pdfPageBoxRect \(pageRect)")
        
        pdfPageView?.tiledLayer.delegate = tiledDelegate
        pdfPageView?.layoutIfNeeded()
        pdfPageView?.setup()
        
        scrollView.contentSize = pdfPageView!.frame.size
        
        // Set up the minimum & maximum zoom scales
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = minScale
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SinglePageViewController: UIScrollViewDelegate
{
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return pdfPageView
    }
}
