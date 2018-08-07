//
//  ReplyTableViewCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 7..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var reply_UserImage: UIImageView!
    @IBOutlet weak var reply_UserEmail: UILabel!
    @IBOutlet weak var reply_UserComment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
