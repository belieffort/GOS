//
//  ScheduleTableViewCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 15..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var schedule_Time: UILabel!
    @IBOutlet weak var schedule_Location: UILabel!
    @IBOutlet weak var schedule_Person: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
