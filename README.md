# SwiftyPDF

## Technical features

 * Paging with system **UIPageViewController**
 * Zooming with **UIScrollView**
 * Renders the PDF fast by converting the page to placeholder image
 * PDF page is scaled and divided into small tiles. Tiles are cached and saved to image files. They are rendered over the placeholder image using the CATiledLayer
 * Using the **NSOperationQueue** for generating images in background


## How to open pdf file

        let path = NSBundle.mainBundle().pathForResource("sample", ofType: "pdf")!
        let url = NSURL(fileURLWithPath: path)
        let pdfViewController = UIStoryboard(name: "Pdf", bundle: nil).instantiateInitialViewController() as! PdfViewController
        pdfViewController.url = url
        presentViewController(pdfViewController, animated: true, completion: nil)
