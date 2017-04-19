//
//  ViewController.swift
//  AppTourDemo
//
//  Created by Prateek Varshney on 20/04/17.
//  Copyright © 2017 PrateekVarshney. All rights reserved.
//

import UIKit
import AppTour

class ViewController: UIViewController, AppTourDelegate {
    
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var nextButton : UIButton!
    let appTour : AppTour = AppTour()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        appTour.delegate = self
        appTour.tintAlpha = 0.65
        
        appTour.actionButton.displaysActionButton = true
        appTour.textLabel.displaysTextLabel = true
        appTour.shouldBlurBackground = false
        
        appTour.textLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        
        appTour.actionButton.layer.cornerRadius = 5.0
        appTour.actionButton.clipsToBounds = true
        appTour.actionButton.font = UIFont.boldSystemFont(ofSize: 22.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        appTour.textLabel.textForLabel = "This text is to make a user aware that this is a label which shows some information about the image."
        appTour.actionButton.actionButtonTitle = "GOT IT"
        let firstAppTourView = appTour.showOnBoardingView(viewController: self, view: self.titleLabel, isViewInTable: false, tableObj: nil, indexPath: nil)
        firstAppTourView.tag = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onBoardingCleared(view: UIView?) {
        print("Onboarding removed : \(String(describing: view?.tag))")
        
        if view?.tag == 1
        {
            appTour.textLabel.textForLabel = "This text is to make a user aware that this is a button which performs some action."
            appTour.actionButton.actionButtonTitle = "GOT IT"
            let secondAppTourView = appTour.showOnBoardingView(viewController: self, view: self.nextButton, isViewInTable: false, tableObj: nil, indexPath: nil)
            secondAppTourView.tag = 2
        }
    }
    
}

