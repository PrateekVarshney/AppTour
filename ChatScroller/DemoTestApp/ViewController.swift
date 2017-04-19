//
//  ViewController.swift
//  DemoTestApp
//
//  Created by Prateek Varshney on 07/04/17.
//  Copyright © 2017 PrateekVarshney. All rights reserved.
//

import UIKit
import ChatScroller
import MapKit

class ViewController: UIViewController, ChatDelegate {
    
    @IBOutlet var map : MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let chView : ChatView = ChatView.init(frame: CGRect.init(x: 10, y: 40, width: 350, height: 400))
        chView.edgeInsets = UIEdgeInsetsMake(1, 7, 1, 0)
        chView.backgroundColor = UIColor.clear
        //chView.selfDestruct = true
        chView.autoHideChatTime = 15.0
        //chView.chatFontSize = 20.0
        chView.delegate = self
        self.view.addSubview(chView)
        self.view.bringSubview(toFront: chView)
        
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing")
//        chView.addChatBubble(withUserName: "Hello", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing")
        
        for i in 0...36
        {
            DispatchQueue.main.asyncAfter(deadline: (.now() + 2.0 + Double(i)), execute: {
                chView.addChatBubble(withUserName: "\(i)", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing", chatId : "\(i)")
            })
        }
        
        /*
        DispatchQueue.main.asyncAfter(deadline: (.now() + 10.0 ), execute: {
            
            for i in 16...35
            {
                DispatchQueue.main.asyncAfter(deadline: (.now() + 2.0 + Double(i - 16)), execute: {
                    chView.addChatBubble(withUserName: "\(i)", userMessage: "Testing Testing Testing Testing Testing Testing Testing Testing", chatId : "\(i)")
                })
            }
        })*/
        
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            // do stuff 42 seconds later
            
            print("Timer Test")
        }
    }
    
    func chatDestroyed(chatId: String?) {
        print("chat \(chatId ?? "none") destroyed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

