//
//  tschead.swift
//  Shedule5.1
//
//  Created by kotmodell on 23.02.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class tschead: UITableViewCell {

    @IBOutlet weak var tlabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellinit()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellinit(){
        tlabel.textColor = UIColor.whiteColor()
    }

}
