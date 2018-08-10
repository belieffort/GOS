//
//  ReplyTableViewCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 7..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

protocol ReplyDeleteDelegate {
    func didTapDelete(_ sender: UIButton)
}

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var reply_UserImage: UIImageView!
    @IBOutlet weak var reply_UserEmail: UILabel!
    @IBOutlet weak var reply_UserComment: UILabel!
    @IBOutlet weak var btnDeleteBackGroundView: UIVisualEffectView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var delegate:ReplyDeleteDelegate?
    
    
    @IBAction func reply_btnDelete(_ sender: Any) {
        //ref.child("Recruitment").child("AutoKey").child("Comment").child("AutoKey")
        //ref.romoValue()
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
