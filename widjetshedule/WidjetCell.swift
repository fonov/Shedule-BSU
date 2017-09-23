//
//  WidjetCell.swift
//  Shedule5.1
//
//  Created by CSergey on 21.04.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class WidjetCell: UITableViewCell {
    
    @IBOutlet weak var widjetnumber: UILabel!
    @IBOutlet weak var widjettypesubject: UILabel!
    @IBOutlet weak var widjetsubject: UILabel!
    @IBOutlet weak var widjetaud: UILabel!
    @IBOutlet weak var widjetview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        widjetnumber.textColor = UIColor.white
        widjetsubject.textColor = UIColor.white
        widjetaud.textColor = UIColor.white
        widjettypesubject.textColor = UIColor.white
        widjettypesubject.clipsToBounds = true
        widjettypesubject.layer.cornerRadius = 3.0
        widjetview.clipsToBounds = true
        widjetview.layer.cornerRadius = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
