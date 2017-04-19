//
//  ChatLbl.swift
//  ChatScroller
//
//  Created by Prateek Varshney on 07/04/17.
//  Copyright © 2017 PrateekVarshney. All rights reserved.
//

import Foundation
import UIKit

class ChatLbl : UILabel
{
    var chatId : String?
    var sessionId : String?
    
    override func drawText(in rect: CGRect) {
        let edge = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edge))
    }
}

extension NSMutableAttributedString
{
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return boundingBox.width
    }
}

