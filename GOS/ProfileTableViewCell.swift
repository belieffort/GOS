//
//  ProfileTableViewCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 15..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {


    @IBOutlet weak var myScheduleSports: UIImageView!
    
    @IBOutlet weak var myScheduleLocation: UILabel!
    @IBOutlet weak var myScheduleTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
