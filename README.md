# SwiftyPDF

 * Paging with system **UIPageViewController**
 * Zooming with **UIScrollView** zooming features
 * Renders the PDF fast by converting the page to placeholder image
 * PDF page is scaled and divided into small tiles. Tiles are cached and saved to image files. They are rendered over the placeholder image using the CATiledLayer
 * Using the **NSOperation** for generating images in background queue
