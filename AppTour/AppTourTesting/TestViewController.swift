//
//  TestViewController.swift
//  AppTour
//
//  Created by Prateek Varshney on 19/04/17.
//  Copyright © 2017 PrateekVarshney. All rights reserved.
//

import Foundation
import UIKit
import AppTour

class TestViewController : UIViewController, AppTourDelegate
{
    
    @IBOutlet var btn1 : UIButton!
    @IBOutlet var btn2 : UIButton!
    
    var appTour : AppTour = AppTour()
    
    override func viewDidLoad() {
    
        appTour.delegate = self
        appTour.tintAlpha = 0.0
        
        appTour.actionButton.displaysActionButton = true
        appTour.textLabel.displaysTextLabel = true
        //appTour.shouldBlurBackground = false
        
        appTour.textLabel.font = UIFont.boldSystemFont(ofSize: 50.0)
        
        appTour.actionButton.layer.cornerRadius = 5.0
        appTour.actionButton.clipsToBounds = true
        appTour.actionButton.font = UIFont.boldSystemFont(ofSize: 50.0)
        
        appTour.textLabel.textForLabel = "Hello hello display some text to test."
        appTour.actionButton.actionButtonTitle = "Donee"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //self.navigationController?.isNavigationBarHidden = true
        let app = appTour.showOnBoardingView(viewController: self, view: self.btn1, isViewInTable: false, tableObj: nil, indexPath: nil)
        
        //app.tag = 11
    }
    
    func onBoardingCleared(view : UIView?) {
        
        print("Cleared : Finally   \(view?.tag)")
    }
}
