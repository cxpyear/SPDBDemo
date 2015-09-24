//
//  BottomBarView.swift
//  spdbapp
//
//  Created by GBTouchG3 on 15/7/27.
//  Copyright (c) 2015年 shgbit. All rights reserved.
//

import UIKit

class BottomBarView: UIView {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnReconnect: UIButton!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    var myTarget = UIViewController()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.hidden = true
        self.btnReconnect.addTarget(self, action: "getReconn", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.lblUserName.text = appManager.appGBUser.name
        
        Poller().start(self, method: "checkstatus:", timerInter: 5.0)
        
        if appManager.netConnect == true {
            self.btnReconnect.hidden = true
        }
    }
 
    
    func checkstatus(timer: NSTimer){
        self.btnReconnect.hidden = (appManager.netConnect == true) ? true : false
    }
    
    //页面下方的“重连”按钮出发的事件
    func getReconn(){
        appManager.starttimer()
    }


    func getBottomInstance(owner: NSObject) -> BottomBarView {
        
        var view = NSBundle.mainBundle().loadNibNamed("BottomBarView", owner: owner, options: nil)[0] as! BottomBarView
        var p = owner as! UIViewController
        println("owner = \(p)")
        view.frame = CGRectMake(0, p.view.frame.height - 49, p.view.frame.width, 49)
        
        myTarget = p
        
        
        view.btnShare.addTarget(p, action: "shareClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.btnHelp.addTarget(p, action: "helpClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.btnBack.addTarget(p, action: "backClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        
//        println("self.btnshare = \(btnShare.frame)")
//        self.btnShare.addTarget(p, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
//        p.view.addSubview(view)
        return view
    }

    func hideOrShowBottomBar(gesture: UITapGestureRecognizer){
        self.hidden = !self.hidden
    }

    
//    func shareClick(sender: UIButton){
//        var shareVC = ShareViewController()
//        println("myTarget = \(myTarget)")
////        var myTargetVC = myTarget
////        println("myTargetVC = \(myTargetVC)")
//        myTarget.presentViewController(shareVC, animated: true, completion: nil)
//    }

    

    
    
}
