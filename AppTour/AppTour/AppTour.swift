//
//  AppTour.swift
//  AppTour
//
//  Created by Prateek Varshney on 19/04/17.
//  Copyright © 2017 PrateekVarshney. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol AppTourDelegate
{
    @objc optional func onBoardingCleared(view : UIView?)
}

public enum Action
{
    case hideOnScreenTap
    case hideOnTintTap
    case hideOnViewTap
    case hideOnButtonTap
    case none
}

public class ActionButton : UILabel
{
    public var displaysActionButton : Bool? = false
    public var actionButtonTitle : String? = "Next"
    public var actionButtonTextColor : UIColor? = UIColor.white
    public var actionButtonBackgroundColor : UIColor? = UIColor.blue
}

public class TextLabel : UILabel
{
    public var displaysTextLabel : Bool? = false
    public var textForLabel : String!
    public var textLabelTextColor : UIColor? = UIColor.white
    public var textLabelBackgroundColor : UIColor? = UIColor.clear
}

public class AppTour
{
    public weak var delegate : AppTourDelegate?
    
    public var shouldAddNavigationBarOffset : Bool = false
    public var shouldBlurBackground : Bool = true
    public var tintColor : UIColor? = UIColor.black
    public var radius : CGFloat?
    public var tintAlpha : CGFloat? = 0.3
    public var hideMode : Action? = Action.hideOnScreenTap
    public var actionButton : ActionButton = ActionButton()
    public var textLabel : TextLabel = TextLabel()
    
    private var onboardView : UIView?
    private var finalXPoint : CGFloat?
    private var finalYPoint : CGFloat?
    
    public init()
    {
        
    }
    
    public func showOnBoardingViewForNavigationItems(viewController : UIViewController!, item : UIBarButtonItem) -> UIView
    {
        var xPoint : CGFloat = 0
        var yPoint : CGFloat = 0
        var width : CGFloat = 0
        var height : CGFloat = 0
        
        let view = item.value(forKey: "view") as? UIView
        if view != nil
        {
            xPoint = view!.frame.origin.x
            yPoint = view!.frame.origin.y
            width = view!.frame.size.width
            height = view!.frame.size.height
        }
        
        let centerPoint : CGPoint = CGPoint.init(x : xPoint+width/2, y : yPoint+height/2)
        finalXPoint = xPoint
        finalYPoint = yPoint
        
        if radius == nil
        {
            radius = width
        }
        
        let croppedImage : UIImage = getScrn(center: centerPoint, radius: radius, vc: viewController!)
        
        let overlayView : UIView = UIView()
        overlayView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        overlayView.backgroundColor = tintColor!.withAlphaComponent(tintAlpha!)
        
        let smallImageView : UIImageView = UIImageView()
        smallImageView.clipsToBounds = true
        smallImageView.isUserInteractionEnabled = true
        smallImageView.frame = CGRect.init(x: 0, y: 0, width: (radius! * 2), height: (radius! * 2))
        smallImageView.contentMode = UIViewContentMode.center
        smallImageView.center = centerPoint
        smallImageView.image = croppedImage
        smallImageView.layer.cornerRadius = CGFloat(radius!)
        
        /*
         let fullImageView : UIImageView = UIImageView()
         fullImageView.clipsToBounds = true
         fullImageView.isUserInteractionEnabled = true
         fullImageView.frame = overlayView.bounds
         fullImageView.contentMode = UIViewContentMode.center
         fullImageView.image = getBlurredImage()
         overlayView.addSubview(fullImageView)
         
         let tintView = UIView()
         tintView.frame = overlayView.bounds
         tintView.backgroundColor = tintColor!.withAlphaComponent(tintAlpha!)
         overlayView.addSubview(tintView)
         */
        
        if self.shouldBlurBackground
        {
            let blurEffect = getBlurEffect()
            overlayView.addSubview(blurEffect)
        }
        
        overlayView.addSubview(smallImageView)
        
        let win : UIWindow = (UIApplication.shared.delegate?.window!)!
        win.addSubview(overlayView)
        
        onboardView = overlayView
        
        if self.textLabel.displaysTextLabel == true
        {
            self.textLabel = addTextLabel(heightView: height, radius: radius!)
        }
        
        if self.actionButton.displaysActionButton == true
        {
            self.actionButton = addNextButton(textLabel: self.textLabel, viewY: yPoint, VHeight: height, radius: radius!)
        }
        
        var viewsArray = [AnyObject]()
        
        switch hideMode!
        {
        case .hideOnScreenTap :
            viewsArray.append(smallImageView)
            viewsArray.append(onboardView!)
            break
        case .hideOnTintTap :
            viewsArray.append(onboardView!)
            break
        case .hideOnViewTap :
            viewsArray.append(smallImageView)
            break
        case .hideOnButtonTap :
            if self.actionButton.displaysActionButton == true
            {
                viewsArray.append(self.actionButton)
            }
            else
            {
                viewsArray.append(smallImageView)
                viewsArray.append(onboardView!)
            }
            break
        default:
            viewsArray.append(smallImageView)
            viewsArray.append(onboardView!)
        }
        
        setupActions(vc: viewController, actionViews: viewsArray)
        
        return overlayView
    }
    
    public func showOnBoardingView(viewController : UIViewController!, view : UIView!, isViewInTable : Bool, tableObj : UITableView?, indexPath : NSIndexPath?) -> UIView
    {
        var xPoint : CGFloat = view.frame.origin.x
        var yPoint : CGFloat = view.frame.origin.y
        let width : CGFloat = view.frame.size.width
        let height : CGFloat = view.frame.size.height
        
        if isViewInTable
        {
            var cellRect : CGRect = tableObj!.rectForRow(at: indexPath! as IndexPath)
            cellRect = cellRect.offsetBy(dx: -tableObj!.contentOffset.x, dy: -tableObj!.contentOffset.y)
            
            cellRect.origin.x += tableObj!.frame.origin.x
            cellRect.origin.y += tableObj!.frame.origin.y
            
            var x = cellRect.origin.x
            var y = cellRect.origin.y
            let cellObject = tableObj!.cellForRow(at: indexPath! as IndexPath)
            
            let subView1 = cellObject?.contentView.viewWithTag(3001)
            x = x + subView1!.frame.origin.x
            y = y + subView1!.frame.origin.y
            
            let superView : UIView? = view.superview
            
            if superView != nil
            {
                x = x + superView!.frame.origin.x
                y = y + superView!.frame.origin.y
            }
            
            xPoint = xPoint + x
            yPoint = yPoint + y
        }
        else
        {
            var superView : UIView? = view.superview
            
            while superView != nil
            {
                xPoint = xPoint + superView!.frame.origin.x
                yPoint = yPoint + superView!.frame.origin.y
                
                superView = superView!.superview
            }
        }
        
        if viewController.navigationController != nil && viewController.navigationController?.isNavigationBarHidden == false && self.shouldAddNavigationBarOffset == true
        {
            yPoint = yPoint + 44
        }
        
        let centerPoint : CGPoint = CGPoint.init(x : xPoint+width/2, y : yPoint+height/2)
        finalXPoint = xPoint
        finalYPoint = yPoint
        
        if radius == nil
        {
            radius = width
        }
        
        let croppedImage : UIImage = getScrn(center: centerPoint, radius: radius, vc: viewController!)
        
        let overlayView : UIView = UIView()
        overlayView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        overlayView.backgroundColor = tintColor!.withAlphaComponent(tintAlpha!)
        
        let smallImageView : UIImageView = UIImageView()
        smallImageView.clipsToBounds = true
        smallImageView.isUserInteractionEnabled = true
        smallImageView.frame = CGRect.init(x: 0, y: 0, width: (radius! * 2), height: (radius! * 2))
        smallImageView.contentMode = UIViewContentMode.center
        smallImageView.center = centerPoint
        smallImageView.image = croppedImage
        smallImageView.layer.cornerRadius = CGFloat(radius!)
        
        /*
        let fullImageView : UIImageView = UIImageView()
        fullImageView.clipsToBounds = true
        fullImageView.isUserInteractionEnabled = true
        fullImageView.frame = overlayView.bounds
        fullImageView.contentMode = UIViewContentMode.center
        fullImageView.image = getBlurredImage()
        overlayView.addSubview(fullImageView)
        
        let tintView = UIView()
        tintView.frame = overlayView.bounds
        tintView.backgroundColor = tintColor!.withAlphaComponent(tintAlpha!)
        overlayView.addSubview(tintView)
        */
        
        if self.shouldBlurBackground
        {
            let blurEffect = getBlurEffect()
            overlayView.addSubview(blurEffect)
        }
        
        overlayView.addSubview(smallImageView)
        
        let win : UIWindow = (UIApplication.shared.delegate?.window!)!
        win.addSubview(overlayView)
        
        onboardView = overlayView
        
        if self.textLabel.displaysTextLabel == true
        {
            self.textLabel = addTextLabel(heightView: view.frame.size.height, radius: radius!)
        }
        
        if self.actionButton.displaysActionButton == true
        {
            self.actionButton = addNextButton(textLabel: self.textLabel, viewY: view.frame.origin.y, VHeight: view.frame.size.height, radius: radius!)
        }
        
        var viewsArray = [AnyObject]()
        
        switch hideMode!
        {
        case .hideOnScreenTap :
            viewsArray.append(smallImageView)
            viewsArray.append(onboardView!)
            break
        case .hideOnTintTap :
            viewsArray.append(onboardView!)
            break
        case .hideOnViewTap :
            viewsArray.append(smallImageView)
            break
        case .hideOnButtonTap :
            if self.actionButton.displaysActionButton == true
            {
                viewsArray.append(self.actionButton)
            }
            else
            {
                viewsArray.append(smallImageView)
                viewsArray.append(onboardView!)
            }
            break
        default:
            viewsArray.append(smallImageView)
            viewsArray.append(onboardView!)
        }
        
        setupActions(vc: viewController, actionViews: viewsArray)
        
        return overlayView
    }
    
    
    private func setupActions(vc : UIViewController , actionViews : Array<AnyObject>)
    {
        for view in actionViews {
            
            let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
            tapGesture.numberOfTapsRequired = 1
            tapGesture.addTarget(self, action: #selector(self.clearOnBoarding(tapGesture:)))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    private func getScrn(center : CGPoint!, radius : CGFloat!, vc : UIViewController!) -> UIImage
    {
        let win : UIWindow = (UIApplication.shared.delegate?.window!)!
        //UIGraphicsBeginImageContext(UIScreen.mainScreen().bounds.size)
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, 0.0)
        win.layer.render(in: UIGraphicsGetCurrentContext()!)
        let sourceImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //UIGraphicsBeginImageContext(CGSize.init(width: (radius*2), height: (radius*2)))
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: (radius*2), height: (radius*2)), true, 0.0)
        sourceImg.draw(at: CGPoint.init(x: (radius - center.x), y: (radius - center.y)))
        let croppedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return croppedImage
    }
    
    private func addTextLabel(heightView : CGFloat, radius : CGFloat) -> TextLabel
    {
        if self.textLabel.textForLabel == nil
        {
            return TextLabel()
        }
        
        self.textLabel.numberOfLines = 0
        self.textLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.textLabel.textColor = self.textLabel.textLabelTextColor
        self.textLabel.backgroundColor = self.textLabel.textLabelBackgroundColor
        self.textLabel.text = self.textLabel.textForLabel
        
        let font = self.textLabel.font!
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let width = screenWidth - 40
        
        let height = getHeightForView(text: self.textLabel.textForLabel!, font: font, width: width)
        
        let yPoint : CGFloat = finalYPoint!
        let viewHeight : CGFloat = heightView
        let centerY = yPoint + viewHeight/2
        
        let labelX : CGFloat = 20
        
        if ( Int(centerY) > Int(screenHeight/2) )
        {
            if self.actionButton.displaysActionButton == true
            {
                let labelY : CGFloat = CGFloat(centerY) - CGFloat(radius) - height - 60;
                self.textLabel.frame = CGRect.init(x: labelX, y: labelY, width: width, height: height)
            }
            else
            {
                let labelY : CGFloat = CGFloat(centerY) - CGFloat(radius) - height - 20;
                self.textLabel.frame = CGRect.init(x: labelX, y: labelY, width: width, height: height)
            }
        }
        else
        {
            let labelY : CGFloat = CGFloat(centerY) + CGFloat(radius) + 10;
            self.textLabel.frame = CGRect.init(x: labelX, y: labelY, width: width, height: height)
        }
        
        onboardView!.addSubview(self.textLabel)
        
        return self.textLabel
    }
    
    private func getHeightForView(text : String, font : UIFont, width : CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect.init(x : 0, y : 0, width : width, height : CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    private func addNextButton(textLabel : TextLabel, viewY : CGFloat, VHeight : CGFloat, radius : CGFloat) -> ActionButton
    {
        self.actionButton.frame = CGRect.init(x: 20, y: 0, width: 50, height: 30)
        self.actionButton.text = self.actionButton.actionButtonTitle
        self.actionButton.textColor = self.actionButton.actionButtonTextColor
        self.actionButton.backgroundColor = self.actionButton.actionButtonBackgroundColor
        self.actionButton.isUserInteractionEnabled = true
        self.actionButton.textAlignment = NSTextAlignment.center
        self.actionButton.sizeToFit()
        
        var labelY : CGFloat = 0;
        let labelWidth : CGFloat = self.actionButton.frame.size.width + 20
        let labelHeight : CGFloat = self.actionButton.frame.size.height + 10
        
        if textLabel.displaysTextLabel == true
        {
            labelY = textLabel.frame.origin.y + textLabel.frame.size.height + 10
        }
        else
        {
            let xPoint : CGFloat = finalXPoint!
            //let viewWidth : Int = Int(view.frame.size.width)
            //let centerX = xPoint + viewWidth/2
            
            self.actionButton.center = CGPoint.init(x: xPoint, y: 0)
            
            let yPoint : Int = Int(viewY)
            let viewHeight : Int = Int(VHeight)
            let centerY = yPoint + viewHeight/2
            let screenHeight = UIScreen.main.bounds.size.height
            
            let spaceLeft = screenHeight - CGFloat(centerY) + CGFloat(radius);
            
            if spaceLeft > 50
            {
                labelY = CGFloat(centerY) + CGFloat(radius)
            }
            else
            {
                labelY = CGFloat(centerY) - CGFloat(radius) - 50
            }
        }
        
        var labelFrame = self.actionButton.frame
        labelFrame.origin.y = labelY
        labelFrame.size.width = labelWidth
        labelFrame.size.height = labelHeight
        self.actionButton.frame = labelFrame
        
        onboardView!.addSubview(self.actionButton)
        
        return self.actionButton
    }
    
    private func getBlurredImage() -> UIImage
    {
        let win : UIWindow = (UIApplication.shared.delegate?.window!)!
        //UIGraphicsBeginImageContext(UIScreen.mainScreen().bounds.size)
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, 0.0)
        win.layer.render(in: UIGraphicsGetCurrentContext()!)
        let sourceImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let blurredImg = blurEffect(image: sourceImg)
        return blurredImg
    }
    
    private func getBlurEffect() -> UIVisualEffectView
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIScreen.main.bounds
        
        //blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        return blurEffectView
    }
    
    private func blurEffect(image : UIImage) -> UIImage
    {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: image)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
    
    @objc private func clearOnBoarding(tapGesture : UITapGestureRecognizer)
    {
        onboardView!.removeFromSuperview()
        self.delegate?.onBoardingCleared?(view : onboardView)
    }
}
