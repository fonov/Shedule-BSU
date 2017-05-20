//
//  UINavigationBarWithSubtitle.swift
//  Shedule5.1
//
//  Created by kotmodell on 18.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import Foundation
import UIKit

class navigationbarsubtitle {
    
    let title: String!
    let subtitle: String!
    
    init(title:String, subtitle:String){
        self.title = title
        self.subtitle = subtitle
    }
    
    var titleView: UIView{
    
        let titleLabel = UILabel(frame: CGRectMake(0, -5, 0, 0))
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRectMake(0, 18, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        subtitleLabel.textColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        subtitleLabel.font = UIFont.boldSystemFontOfSize(12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff > 0 {
            var frame = titleLabel.frame
            frame.origin.x = widthDiff / 2
            titleLabel.frame = CGRectIntegral(frame)
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            titleLabel.frame = CGRectIntegral(frame)
        }
        
    return titleView
    }
    
    
    
}