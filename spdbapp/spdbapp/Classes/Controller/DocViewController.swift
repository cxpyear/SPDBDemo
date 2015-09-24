//
//  DocViewController.swift
//  spdbapp
//
//  Created by tommy on 15/5/8.
//  Copyright (c) 2015年 shgbit. All rights reserved.
//

import UIKit
import Alamofire

class DocViewController: UIViewController,UIWebViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIScrollViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var btnLeftBottom: UIButton!
    @IBOutlet weak var btnRightBottom: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var txtShowTotalPage: UITextField!
    @IBOutlet weak var txtShowCurrentPape: UITextField!
    @IBOutlet weak var btnPrevious: UIButton!
 
    @IBOutlet weak var btnAfter: UIButton!
    
    var isScreenLocked: Bool = false

    var fileIDInfo: String?
    var fileNameInfo: String?
    
    var timer = Poller()

    var topBarView = TopbarView()
    var bottomBarView = BottomBarView()

    var totalPage = 0
    var currentPage = 0
//    var docPath = String()
    
    @IBOutlet weak var docView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        docPath = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(fileIDInfo!).pdf")
        loadLocalPDFFile()
        totalPage = initfile()
        
        
        topBarView = TopbarView.getTopBarView(self)
        topBarView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(topBarView)
        
        bottomBarView = BottomBarView().getBottomInstance(self)
        self.view.addSubview(bottomBarView)
        
        txtShowCurrentPape.delegate = self
        txtShowTotalPage.text = "共\(totalPage)页"
        self.currentPage = 1
        
        self.docView.scrollView.delegate = self
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "hideOrShowBottomBar:")
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "backToMainVC", name: HistoryInfoDidDeleteNotification, object: nil)
//    }
//    
//    func backToMainVC(){
//        var storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        var registerVC = storyBoard.instantiateViewControllerWithIdentifier("view") as! RegisViewController
//        self.presentViewController(registerVC, animated: true, completion: nil)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: HistoryInfoDidDeleteNotification, object: nil)
//    }
    
    
    func helpClick(){
        var newVC = NewFeatureViewController()
        self.presentViewController(newVC, animated: true, completion: nil)
    }
    
    func shareClick(){
        var shareVC = ShareViewController()
        self.presentViewController(shareVC, animated: true, completion: nil)
    }
    
    func backClick(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hideOrShowBottomBar(gesture: UITapGestureRecognizer){
        self.bottomBarView.hidden = !self.bottomBarView.hidden
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.txtShowCurrentPape{
            self.txtShowCurrentPape.endEditing(true)
        }
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField){
        if textField == self.txtShowCurrentPape{
            if textField.text.isEmpty{
                return
            }
            
            var value = self.txtShowCurrentPape.text
            var temp = String(value)
            var page = temp.toInt()!
            if page <= 0{
                return
            }
            skipToPage(page)
            currentPage = page
           
        }
    }
    
    /**
    跳转到pdf指定的页码
    
    :param: num 指定的pdf跳转页码位置
    */
    func skipToPage(num: Int){
        var totalPDFheight = docView.scrollView.contentSize.height
        var pageHeight = CGFloat(totalPDFheight / CGFloat(totalPage))
    
        var specificPageNo = num
        if specificPageNo <= totalPage{
            
            var value2 = CGFloat(pageHeight * CGFloat(specificPageNo - 1))
            var offsetPage = CGPointMake(0, value2)
            docView.scrollView.setContentOffset(offsetPage, animated: true)
        }
        println("currentpage = \(currentPage)")
    }
    
    /**
    跳转到pdf文档第一页
    */
    @IBAction func btnToFirstPageClick(sender: UIButton) {
        skipToPage(1)
        currentPage = 1
        self.txtShowCurrentPape.text = String(currentPage)
    }
    
    /**
    跳转到pdf文档最后一页
    */
    @IBAction func btnToLastPageClick(sender: UIButton) {
        skipToPage(totalPage)
        currentPage = totalPage
        self.txtShowCurrentPape.text = String(currentPage)
    }
    
    /**
    跳转到pdf文档下一页
    */
    @IBAction func btnToNextPageClick(sender: UIButton) {
        if currentPage < totalPage  {
            ++currentPage
            skipToPage(currentPage)
            self.txtShowCurrentPape.text = String(currentPage)
            
        }
    }

    
    /**
    跳转到pdf文档上一页
    */
    @IBAction func btnToPreviousPageClick(sender: UIButton) {
        if currentPage > 1 {
            --currentPage
            skipToPage(currentPage)
            
            self.txtShowCurrentPape.text = String(currentPage)
        }
        println("==============1")
    }
    
    
    func autoHideBottomBarView(timer: NSTimer){
        if self.bottomBarView.hidden == false{
            self.bottomBarView.hidden = true
        }
    }
    
    
    
    
    /**
    返回当前pdf文件的总页数
    
    :returns: 当前pdf文档总页数
    */
    func initfile() -> Int {
        var dataPathFromApp = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(fileIDInfo!).pdf")
        var path: CFString = CFStringCreateWithCString(nil, dataPathFromApp, CFStringEncoding(CFStringBuiltInEncodings.UTF8.rawValue))
        var url: CFURLRef = CFURLCreateWithFileSystemPath(nil , path, CFURLPathStyle.CFURLPOSIXPathStyle, 0)
       
        
        if let document = CGPDFDocumentCreateWithURL(url){
            var totalPages = CGPDFDocumentGetNumberOfPages(document)
            return totalPages
        }else{
            self.docView.hidden = true
            self.topView.hidden = true
            UIAlertView(title: "提示", message: "当前服务器中不存在该文件", delegate: self, cancelButtonTitle: "确定").show()
            return 0
        }
    }
    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        var pdfHeight = scrollView.contentSize.height
        var onePageHeight = pdfHeight / CGFloat(totalPage)
        
        var page = (scrollView.contentOffset.y) / onePageHeight
        var p = Int(page + 0.5)
        self.txtShowCurrentPape.text = "\(p + 1)"
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
       
    //加锁
    @IBAction func addLock(sender: UIButton) {
        self.isScreenLocked = !self.isScreenLocked
        
        var imageName = (self.isScreenLocked == true) ? "Lock-50" : "Unlock-50"
        sender.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        topBarView.lblIsLocked.text = (self.isScreenLocked == true) ? "当前屏幕已锁定" : ""
    }
    
    override func shouldAutorotate() -> Bool {
        return !self.isScreenLocked
    }
    
    
    /**
    加载当前pdf文档
    */
    func loadLocalPDFFile(){
        var filePath: String = NSHomeDirectory().stringByAppendingPathComponent("Documents/\(self.fileIDInfo!).pdf")
        var urlString = NSURL(fileURLWithPath: "\(filePath)")
        var request = NSURLRequest(URL: urlString!)
        self.docView.loadRequest(request)
        skipToPage(1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
