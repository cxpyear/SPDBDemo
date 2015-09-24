//
//  ShareViewController.swift
//  spdbapp
//
//  Created by GBTouchG3 on 15/9/22.
//  Copyright (c) 2015年 shgbit. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        showShareView()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func showShareView(){
        var shareUrl = "http://www.shgbit.com/spadapp"
        
        var btn = UIButton()
        btn.frame = CGRectMake(50, 20, 100, 40)
        btn.layer.cornerRadius = 8
        btn.setTitle("返回", forState: UIControlState.Normal)
        btn.addTarget(self, action: "btnBack:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.backgroundColor = SHColor(143, 1, 43)
        self.view.addSubview(btn)
        
        var webView = UIWebView()
        webView.frame = CGRectMake(0, 80, self.view.frame.width, self.view.frame.height - 80)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: shareUrl)!))
        self.view.addSubview(webView)
    }
    
    func btnBack(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
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
