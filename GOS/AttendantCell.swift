//
//  AttendantCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 2..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class AttendantCell: UITableViewCell {

    @IBOutlet weak var attendantImage: UIImageView!
    @IBOutlet weak var attendantEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
