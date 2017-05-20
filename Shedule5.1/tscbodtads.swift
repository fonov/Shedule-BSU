//
//  tscbodtads.swift
//  Shedule5.1
//
//  Created by CSergey on 14.04.16.
//  Copyright © 2016 kotmodell. All rights reserved.
//

import UIKit

class tscbodtads: UITableViewCell {

    @IBOutlet weak var ltimesh: UILabel!
    @IBOutlet weak var ltimesi: UILabel!
    @IBOutlet weak var lnumber: UILabel!
    @IBOutlet weak var ltimefh: UILabel!
    @IBOutlet weak var ltimefi: UILabel!
    @IBOutlet weak var vsheduleindicator: UIView!
    @IBOutlet weak var lsubsubject: UILabel!
    @IBOutlet weak var lsabject: UILabel!
    @IBOutlet weak var lsubteacher: UILabel!
    @IBOutlet weak var lteacher: UILabel!
    @IBOutlet weak var laud: UILabel!
    @IBOutlet weak var viewads: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        vsheduleindicator.clipsToBounds = true
        vsheduleindicator.layer.cornerRadius = 2.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}