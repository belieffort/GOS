//
//  ProfileUserPlanTableViewCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 13..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class ProfileUserPlanTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userPlan_Title:UILabel!
    @IBOutlet weak var userPlan_Location:UILabel!
    @IBOutlet weak var userPlan_Time:UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
