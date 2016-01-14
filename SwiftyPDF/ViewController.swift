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
    var viewControllers = [SinglePageViewController?]()
    var currentPageIdx: Int?
    private var pendingPageIdx: Int?
    var doc: CGPDFDocument?

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
            for _ in 1...ctPages
            {
                viewControllers.append(nil)
            }
        }
        return doc
    }
    
    private func pageIndexOfViewController(viewController: UIViewController) -> Int?
    {
        for (idx,vc) in viewControllers.enumerate()
        {
            if vc == viewController
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
            if viewControllers[0] == nil
            {
                let vc = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as! SinglePageViewController
                viewControllers[0] = vc
                
                let page = CGPDFDocumentGetPage(document(), 1)!
                vc.tiledDelegate = TiledDelegate(page: page)
                
                currentPageIdx = 0
            }
            
            pageController.setViewControllers([viewControllers[0]!], direction: .Forward, animated: false, completion: nil)
        }
    }
    
    @IBAction func zoom2x(sender: AnyObject)
    {
        if let vc = viewControllers[currentPageIdx!]
        {
            vc.pdfPageView.zoom *= 2
            vc.pdfPageView.tiledLayer.transform = CATransform3DMakeScale(vc.pdfPageView.zoom, vc.pdfPageView.zoom, 1.0)
        }
    }

    @IBAction func zoomOut(sender: AnyObject)
    {
        if let vc = viewControllers[currentPageIdx!]
        {
            vc.pdfPageView.zoom /= 2
            vc.pdfPageView.tiledLayer.transform = CATransform3DMakeScale(vc.pdfPageView.zoom, vc.pdfPageView.zoom, 1.0)
        }
    }
}

extension ViewController: UIPageViewControllerDataSource
{
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if let idx = pageIndexOfViewController(viewController) where idx < viewControllers.count-1
        {
            var nextVC = viewControllers[idx+1]
            
            if nextVC == nil
            {
                nextVC = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as? SinglePageViewController
                viewControllers[idx+1] = nextVC
                
                let page = CGPDFDocumentGetPage(document(), idx+2)!
                nextVC!.tiledDelegate = TiledDelegate(page: page)

            }
            return nextVC
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if let idx = pageIndexOfViewController(viewController) where idx > 0
        {
            var prevVC = viewControllers[idx-1]
            if prevVC == nil
            {
                prevVC = storyboard!.instantiateViewControllerWithIdentifier("pdfPage") as? SinglePageViewController
                viewControllers[idx-1] = prevVC
                
                let page = CGPDFDocumentGetPage(document(), idx)!
                prevVC!.tiledDelegate = TiledDelegate(page: page)

            }
            
            return prevVC
        }
        return nil
    }
}

extension ViewController: UIPageViewControllerDelegate
{
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController])
    {
        print("pending:")
        if let vc = pendingViewControllers.last
        {
            pendingPageIdx = pageIndexOfViewController(vc)
            print(pendingPageIdx)
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        print("previous:")
        for vc in previousViewControllers
        {
            let idx = pageIndexOfViewController(vc)
            print(idx)
        }
        
        if completed
        {
            currentPageIdx = pendingPageIdx
        }
    }
}
