//
//  LikeReplyTableViewCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 8..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class LikeReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var like_ReplyUserImage: UIImageView!

    @IBOutlet weak var like_ReplyUserEmail: UILabel!
    
    @IBOutlet weak var like_ReplyUserComment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
