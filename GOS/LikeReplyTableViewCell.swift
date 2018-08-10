//
//  LikeReplyTableViewCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 8..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

protocol Like_ReplyDeleteDelegate {
    func didTapDelete(_ sender: UIButton)
}


class LikeReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var like_ReplyUserImage: UIImageView!

    @IBOutlet weak var like_ReplyUserEmail: UILabel!
    
    @IBOutlet weak var like_ReplyUserComment: UILabel!
    @IBOutlet weak var btnDeleteBackGroundView: UIVisualEffectView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var delegate:Like_ReplyDeleteDelegate?

    
    
    @IBAction func likeReply_btnDelete(_ sender: Any) {
        delegate?.didTapDelete(btnDelete)
        print("Delete")

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
