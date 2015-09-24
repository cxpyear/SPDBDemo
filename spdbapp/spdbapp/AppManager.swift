//
//  AppManager.swift
//  spdbapp
//
//  Created by tommy on 15/5/11.
//  Copyright (c) 2015年 shgbit. All rights reserved.
//

import Foundation
import Alamofire

class Poller {
    var timer: NSTimer?
    
    func start(obj: NSObject, method: Selector,timerInter: Double) {
        stop()
        
        timer = NSTimer(timeInterval: timerInter, target: obj, selector: method , userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }
    
    func stop() {
        if (isRun()){
            timer?.invalidate()
        }
    }
    
    func isRun() -> Bool{
        return (timer != nil && timer?.valid != nil)
    }
}


class AppManager : NSObject {
    dynamic var current = GBMeeting()
    dynamic var netConnect: Bool = false
    dynamic var wifiConnect : Bool = false
    dynamic var appGBUser = GBUser()
    dynamic var server = Server()
    

    var count = 0
    
    override init(){
        super.init()
        println("========aaaaaaaaa")
        self.netConnect = false
        self.wifiConnect = false
        
        starttimer()
        startWifiCheckTimer()
        
        //定时器每隔2s检测当前current是否发生变化
        
        if bNeedRefresh == true{
            Poller().start(self, method: "getCurrent:", timerInter: 10.0)
        }
        else{
            self.current = builder.loadOffLineMeeting()
        }
    }

    
    /**
    每隔3s轮询检测当前wifi连接状态
    */
    func startWifiCheckTimer(){
        Poller().start(self, method: "checkWifiConnect:", timerInter: 5.0)
    }
    func checkWifiConnect(timer: NSTimer){
        if Reachability.reachabilityForInternetConnection().currentReachabilityStatus != Reachability.NetworkStatus.NotReachable{
            self.wifiConnect = true
        }
        else{
            self.wifiConnect = false
        }
    }

    
    
    /**
    每隔3s轮询检测当前心跳,服务器连接状态
    */
    func starttimer(){
        Poller().start(self, method: "startHeartbeat:",timerInter: 5.0)
    }
    func startHeartbeat(timer: NSTimer){
        var url = server.heartBeatServiceUrl + "/" + GBNetwork.getMacId()
        Alamofire.request(.GET, url).responseJSON(options: NSJSONReadingOptions.MutableContainers) { (request, response, data, error) -> Void in
            if response?.statusCode == 200{
                self.netConnect = true
                self.count = 0
            }
            else{
                self.netConnect = false
                self.count++
                if self.count == 3{
                    self.count = 0
                    timer.invalidate()
                }
            }
        }
    }
    

    /**
    轮询检测当前会议
    
    :param: timer 定时器轮询检测当前会议时间间隔
    */
    func getCurrent(timer: NSTimer){
        
//        if self.wifiConnect == true && self.netConnect == true{
            self.current = builder.LocalCreateMeeting()
            NSNotificationCenter.defaultCenter().postNotificationName(CurrentDidChangeNotification, object: nil, userInfo: [CurrentDidChangeName: self.current.agendas])
        
            var agenda = AgendaViewController()
        
            agenda.gbAgendInfo = self.current.agendas
        
//        }else{
//            self.current = builder.loadOffLineMeeting()
//        }

    }

}





