//
//  ChatView.swift
//  ChatScroller
//
//  Created by Prateek Varshney on 07/04/17.
//  Copyright © 2017 PrateekVarshney. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol ChatDelegate
{
    @objc optional func chatDestroyed(chatId : String?, sessionId: String?)
}

public class ChatView : UIView
{
    public weak var delegate : ChatDelegate?
    public var edgeInsets : UIEdgeInsets?
    public var nameFont : UIFont?
    public var chatFont : UIFont?
    public var chatFontSize : CGFloat?
    public var nameTextColor : UIColor?
    public var chatTextColor : UIColor?
    public var chatBackgroundColour : UIColor?
    
    public var selfDestruct : Bool = false
    public var autoHideChatTime : Double = 3.0
    {
        didSet
        {
            do
            {
                try checkPositive(value: autoHideChatTime)
            }
            catch
            {
                print("Cannot set less than 0")
                autoHideChatTime = oldValue
            }
        }
    }
    
    public var chatHolderView : UIView!
    private var chatScrollerView : UIScrollView!
    
    override required public init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        
        chatHolderView = UIView.init(frame: self.bounds)
        chatScrollerView = UIScrollView.init(frame: CGRect.zero)
        var frame = chatScrollerView.frame
        frame.origin.y = chatHolderView.frame.size.height
        frame.size.width = chatHolderView.frame.size.width
        chatScrollerView.frame = frame
        self.addSubview(chatHolderView)
        chatHolderView.addSubview(chatScrollerView)
        chatScrollerView.clipsToBounds = true
        
        self.isUserInteractionEnabled = false
        chatHolderView.isUserInteractionEnabled = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkPositive(value : Double) throws
    {
        guard value >= 0.0 else {
            throw Errors.NegativeError
        }
    }
    
    public func addChatBubble(withUserName userName : String, userMessage : String, chatId : String?, sessionId : String?)
    {
        var x : CGFloat = 10.0
        let y : CGFloat = 10.0
        var width : CGFloat = 200.0
        let height : CGFloat = 1.0
        
        var r : CGFloat = 15.0
        
        if self.edgeInsets != nil
        {
            x = self.edgeInsets!.left
            r = self.edgeInsets!.right
            width = self.frame.size.width - x - (r > 0 ? r : 0) - 10.0
        }
        
        let fontSize = chatFontSize != nil ? chatFontSize! : 10.0
        
        var namefont : UIFont = nameFont != nil ? nameFont! : UIFont.boldSystemFont(ofSize: fontSize)
        namefont = chatFontSize != nil ? namefont.withSize(chatFontSize!) : namefont.withSize(fontSize)
        
        var chatfont : UIFont = chatFont != nil ? chatFont! : UIFont.systemFont(ofSize: fontSize)
        chatfont = chatFontSize != nil ? chatfont.withSize(chatFontSize!) : chatfont.withSize(fontSize)
        
        let textColour : UIColor = chatTextColor != nil ? chatTextColor! : UIColor.white
        
        let nameAttr = [ NSFontAttributeName: namefont, NSForegroundColorAttributeName : textColour ] as [String : Any]
        let chatAttr = [ NSFontAttributeName: chatfont, NSForegroundColorAttributeName : textColour ] as [String : Any]
        let chatString = NSMutableAttributedString()
        let nameStr1 = NSMutableAttributedString(string: userName, attributes: nameAttr)
        let nameStr2 = NSMutableAttributedString(string: " : ", attributes: nameAttr)
        let chatStr1 = NSMutableAttributedString(string: userMessage, attributes: chatAttr)
        chatString.append(nameStr1)
        chatString.append(nameStr2)
        chatString.append(chatStr1)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.5
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        chatString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange.init(location: 0, length: chatString.length))
        
        let chatLbl = ChatLbl.init(frame: CGRect.init(x: x, y: y, width: width, height: height))
        chatLbl.clipsToBounds = true
        chatLbl.layer.cornerRadius = 5.0
        chatLbl.backgroundColor = chatBackgroundColour ?? UIColor.init(white: 0.0, alpha: 0.5)
        chatLbl.textColor = chatTextColor ?? UIColor.white
        chatLbl.numberOfLines = 2
        chatLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        chatLbl.textAlignment = NSTextAlignment.left
        chatLbl.attributedText = chatString
        chatLbl.chatId = chatId
        chatLbl.sessionId = sessionId
        
        let h1 = chatString.height(withConstrainedWidth : .greatestFiniteMagnitude)
        var w = chatString.width(withConstrainedHeight: 1.0)
        var h = chatString.height(withConstrainedWidth : (self.frame.size.width - 20.0))
        
        if w > (self.frame.size.width - 20.0 - (x+r))
        {
            w = self.frame.size.width - 20.0 - (x+r)
        }

        if h > (h1 + 5.0)
        {
            h = h1 * 2
        }
        
        var yN = self.chatScrollerView.frame.size.height + 5.0
        
        var firstVisibleChat = 1
        var lastVisibleChat = 0
        var frame3 = self.chatScrollerView.frame
        if (frame3.height + h + 15.0) < self.frame.size.height
        {
            frame3.origin.y = frame3.origin.y - h - 15.0
            frame3.size.height = frame3.size.height + h + 15.0
            self.chatScrollerView.frame = frame3
        }
        else
        {
            var lastView = self.chatScrollerView.subviews.last as? ChatLbl
            if lastView != nil
            {
                for chatBubbleLbl in self.chatScrollerView.subviews
                {
                    if chatBubbleLbl is ChatLbl
                    {
                        if chatBubbleLbl.tag > lastView!.tag
                        {
                            lastView = chatBubbleLbl as? ChatLbl
                        }
                    }
                }
                
                yN = lastView!.frame.origin.y + lastView!.frame.size.height + 5.0
                self.isUserInteractionEnabled = true
                chatHolderView.isUserInteractionEnabled = true
            }
        }
        
        if self.chatScrollerView.subviews.count > 0
        {
            for chatBubbleLbl in self.chatScrollerView.subviews
            {
                if chatBubbleLbl is ChatLbl
                {
                    if chatBubbleLbl.tag > firstVisibleChat
                    {
                        firstVisibleChat = chatBubbleLbl.tag
                    }
                }
            }
        }

        for chatBubbleLbl in self.chatScrollerView.subviews
        {
            if chatBubbleLbl is ChatLbl
            {
                if chatBubbleLbl.tag < firstVisibleChat
                {
                    firstVisibleChat = chatBubbleLbl.tag
                }
                
                if chatBubbleLbl.tag > lastVisibleChat
                {
                    lastVisibleChat = chatBubbleLbl.tag
                }
                //visibleChats = visibleChats + 1
                //chatBubbleLbl.tag = visibleChats
            }
        }
        
        var frame = chatLbl.frame
        //frame.origin.y = self.chatScrollerView.frame.size.height - h - 15.0
        frame.origin.y = yN
        frame.size.width = w + 20.0
        frame.size.height = h + 10.0
        chatLbl.frame = frame
        chatLbl.layer.cornerRadius = chatLbl.frame.size.height / 2.0
        
        /*
        var visibleChats = 0
        for chatBubbleLbl in self.chatScrollerView.subviews
        {
            if chatBubbleLbl is ChatLbl
            {
                visibleChats = visibleChats + 1
                var frame2 = chatBubbleLbl.frame
                frame2.origin.y = frame2.origin.y - (frame.size.height + 10.0)
                chatBubbleLbl.frame = frame2
                chatBubbleLbl.tag = visibleChats
            }
        }
        */
        
        chatLbl.tag = lastVisibleChat + 1
        print("Adding Now \(lastVisibleChat + 1)")
        self.chatScrollerView.addSubview(chatLbl)
        
        let firstChatBbl = self.chatScrollerView.viewWithTag(firstVisibleChat) as! ChatLbl
        let fY = firstChatBbl.frame.origin.y
        let lY = frame.origin.y + frame.size.height + 15.0
        
        self.chatScrollerView.contentSize = CGSize.init(width: self.chatScrollerView.frame.size.width, height: (lY - fY))
        self.chatScrollerView.contentOffset = CGPoint.init(x: 0.0, y: (lY - 10.0 - self.chatScrollerView.frame.size.height))
        
        if selfDestruct
        {
            DispatchQueue.main.asyncAfter(deadline: (.now() + autoHideChatTime), execute: {
                self.destroyLbl(lbl: chatLbl)
            })
        }
    }
    
    private func destroyLbl(lbl : ChatLbl)
    {
        print("Removing Now \(lbl.tag)")
        lbl.removeFromSuperview()
        self.delegate?.chatDestroyed!(chatId: lbl.chatId, sessionId: lbl.sessionId)
        
        var visibleChats = 0
        for chatBubbleLbl in self.chatScrollerView.subviews
        {
            if chatBubbleLbl is ChatLbl
            {
                visibleChats = visibleChats + 1
                //chatBubbleLbl.tag = visibleChats
            }
        }
        
        var firstView = self.chatScrollerView.viewWithTag(lbl.tag + 1) as? ChatLbl
        var lastView = firstView
        
        if firstView != nil
        {
            for chatBubbleLbl in self.chatScrollerView.subviews
            {
                if chatBubbleLbl is ChatLbl
                {
                    if chatBubbleLbl.tag < firstView!.tag
                    {
                        firstView = chatBubbleLbl as? ChatLbl
                    }
                    
                    if chatBubbleLbl.tag > lastView!.tag
                    {
                        lastView = chatBubbleLbl as? ChatLbl
                    }
                }
            }
            
            let yF : CGFloat = firstView!.frame.origin.y
            let yL : CGFloat = lastView!.frame.origin.y + lastView!.frame.size.height + 5.0
            
            if (yL - yF) < self.chatHolderView.frame.size.height
            {
                var nY : CGFloat = 0.0
                self.chatScrollerView.contentOffset = CGPoint.init(x: 0.0, y: 0.0)
                
                for chatBubbleLbl in self.chatScrollerView.subviews
                {
                    if chatBubbleLbl is ChatLbl
                    {
                        var frame = chatBubbleLbl.frame
                        frame.origin.y = nY
                        chatBubbleLbl.frame = frame
                        nY = chatBubbleLbl.frame.origin.y + chatBubbleLbl.frame.size.height + 5.0
                    }
                }
                
                var frame = self.chatScrollerView.frame
                frame.origin.y = self.chatHolderView.frame.size.height - nY
                frame.size.height = nY
                self.chatScrollerView.frame = frame
                
                self.isUserInteractionEnabled = false
                chatHolderView.isUserInteractionEnabled = false
            }
        }
        else
        {
            var frame = self.chatScrollerView.frame
            frame.origin.y = self.chatHolderView.frame.size.height
            frame.size.height = 0.0
            self.chatScrollerView.frame = frame
        }
    }
}
