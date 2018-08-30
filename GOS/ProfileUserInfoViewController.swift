//
//  ProfileUserInfoViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 13..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import TagListView
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileUserInfoViewController: UIViewController, TagListViewDelegate {
    
    @IBOutlet weak var userInfoView:UIView!
    @IBOutlet weak var userScheduleView:UIView!

    @IBOutlet weak var userPlainTableView:UITableView!
    @IBOutlet weak var userImage:UIImageView!
    @IBOutlet weak var userEmail:UILabel!
    @IBOutlet weak var interestLbl:UILabel!
    @IBOutlet weak var userInterestSports: TagListView!
    @IBOutlet weak var followText: UIButton!
    
    var ref: DatabaseReference!
    var plans: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userUid = Auth.auth().currentUser?.uid
    var passEmail:String?
    var passUID:String?
    var passImgae:String?
    var passKeyBox:[String] = []
    
    var userImageURL:String?
    var anotherUserUID:String?
    
    var friendsUID:[String] = []
    var friendTF:Bool!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        interestLbl.isHidden = true
//        ref = Database.database().reference()
//        getUserUID()
//        getUserPlan()
//        getUserImageURL()
//        userInterestSports.delegate = self
//        userEmail.text = passEmail
    }
    
    
    @IBAction func switchViews(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            userInfoView.alpha = 1
            userScheduleView.alpha = 0
        }else {
            userInfoView.alpha = 0
            userScheduleView.alpha = 1

        }
        
    }
    

//    func getUserPlan() {
//           _refHandle = self.ref.child("Users").child("\(passUID!)").child("Join")
//                .observe(.childAdded, with: { [weak self] (snapshot) in
//                    guard let strongSelf = self else { return }
//                    strongSelf.plans.append(snapshot)
//                    strongSelf.userPlainTableView.insertRows(at: [IndexPath(row: strongSelf.plans.count-1, section: 0)], with: .automatic)
//            })
//    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserInfo" {
            let userInfoVC = segue.destination as! ProfileUserInfoVC
            userInfoVC.passedEmail = passEmail
        } else if segue.identifier == "UserPlan" {
            let userPlanVC = segue.destination as! ProfileUserPlanVC
            userPlanVC.passUID = passUID
        }
    }
}




//내 프로필 이미지 URL
//        func getUserImageURL() {
//
//            ref.child("Users").child(userUID!).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
//                if let userInfo = snapshot.value as? String {
//                    self.userImageURL = userInfo
//                } else {
//                }
//            })
//        }
