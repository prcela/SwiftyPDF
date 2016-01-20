//
//  ViewController.swift
//  SwiftyPDF
//
//  Created by prcela on 12/01/16.
//  Copyright © 2016 100kas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pageController: UIPageViewController!
    var pages = [PdfPageDesc]()
    var currentPageIdx: Int?
    private var pendingPageIdx: Int?
    var doc: CGPDFDocument?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onPageTilesSaved:", name: pageTilesSavedNotification, object: nil)
        
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func document() -> CGPDFDocument?
    {
        if(doc == nil)
        {
            let path = NSBundle.mainBundle().pathForResource("sample", ofType: "pdf")!
            let docURL = NSURL(fileURLWithPath: path)
            doc = CGPDFDocumentCreateWithURL(docURL)
            
            let ctPages = CGPDFDocumentGetNumberOfPages(doc)
            for idx in 1...ctPages
            {
                let pageDesc = PdfPageDesc(pdfPage: CGPDFDocumentGetPage(doc, idx)!)
                pages.append(pageDesc)
                pageDesc.createPlaceHolder()
            }
        }
        return doc
    }
    
    private func pageIndexOfViewController(viewController: UIViewController) -> Int?
    {
        for (idx,pageDesc) in pages.enumerate()
        {
            if viewController == pageDesc.viewController
            {
                return idx
            }
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.identifier == "embed"
        {
            
            pageController = segue.destinationViewController as! UIPageViewController
            
            pageController.dataSource = self
            pageController.delegate = self
            
            document()
            ImageCreator.clearCachedFiles()
            
            let page = pages.first!
            if page.viewController == nil
            {
                page.viewController = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as? SinglePageViewController
                page.viewController!.pageDesc = page
                
                
                currentPageIdx = 0
            }
            
            pageController.setViewControllers([page.viewController!], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    func onPageTilesSaved(notification: NSNotification)
    {
        let pageIdx = notification.object as! Int
        print("Tiles saved for page: \(pageIdx)")
        
        for pageDesc in pages
        {
            if pageIdx == CGPDFPageGetPageNumber(pageDesc.pdfPage)
            {
                pageDesc.viewController?.imageScrollView?.tilingView?.setNeedsDisplay()
            }
        }
    }

}

extension ViewController: UIPageViewControllerDataSource
{
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if let idx = pageIndexOfViewController(viewController) where idx < pages.count-1
        {
            let nextPage = pages[idx+1]
            
            if nextPage.viewController == nil
            {
                nextPage.viewController = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as? SinglePageViewController
                nextPage.viewController?.pageDesc = nextPage
            }
            return nextPage.viewController
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if let idx = pageIndexOfViewController(viewController) where idx > 0
        {
            let prevPage = pages[idx-1]
            if prevPage.viewController == nil
            {
                prevPage.viewController = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as? SinglePageViewController
                prevPage.viewController?.pageDesc = prevPage
            }
            
            return prevPage.viewController
        }
        return nil
    }
}

extension ViewController: UIPageViewControllerDelegate
{
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController])
    {
        if let vc = pendingViewControllers.last
        {
            pendingPageIdx = pageIndexOfViewController(vc)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed
        {
            for previousVC in previousViewControllers
            {
                if let imageScrollView = (previousVC as? SinglePageViewController)?.imageScrollView
                {
                    // reset scale, remove tiling view
                    imageScrollView.zoomScale = imageScrollView.minimumZoomScale
                    imageScrollView.tilingView?.removeFromSuperview()
                    imageScrollView.tilingView = nil
                }
            }
            
            currentPageIdx = pendingPageIdx
        }
    }
}
