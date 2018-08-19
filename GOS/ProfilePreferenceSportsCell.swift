//
//  ProfilePreferenceSportsCell.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 17..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

protocol SelectionSportsDelegate {
    func didTapSelect(_ sender: UIButton)
}

class ProfilePreferenceSportsCell: UITableViewCell, SSRadioButtonControllerDelegate {

    @IBOutlet weak var btnSports: UIButton!
    var radioController: SSRadioButtonsController?
    var selectionDelegate:SelectionSportsDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        radioController = SSRadioButtonsController(buttons: btnSports)
        radioController!.delegate = self
        radioController!.shouldLetDeSelect = true
    }
    
    @IBAction func btnSelectSports(_ sender: Any) {
        selectionDelegate?.didTapSelect(btnSports)
    }
    
    
    func didSelectButton(selectedButton: UIButton?) {
//        NSLog(" \(btnSports)" )
//        selectionDelegate?.didTapSelect(btnSports)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
