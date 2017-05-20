//
//  SettingAboutLogo.swift
//  Shedule5.1
//
//  Created by kotmodell on 26.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class SettingAboutLogo: UITableViewCell {

    @IBOutlet weak var imglogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imglogo.image = UIImage(named: "icon175x175")
        imglogo.clipsToBounds = true
        imglogo.layer.cornerRadius = 20.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
