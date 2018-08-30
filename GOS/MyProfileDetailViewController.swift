//
//  MyProfileDetailViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 31..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


//TODO - 이미지를 파이어베이스에서 불러오는데 12초가 걸림
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MyProfileDetailViewController: UIViewController {
    
    @IBOutlet weak var myAccountView: UIView!
    @IBOutlet weak var myPreferenceSportsView: UIView!
    
    @IBOutlet weak var segmentCheck: UISegmentedControl!
    var ref: DatabaseReference!
    var myIntroduce: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    let userUID = Auth.auth().currentUser?.uid
    let storageRef = Storage.storage().reference()
    var btnStore:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnStore = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = self.btnStore
    }
    
    
    @objc func addTapped() {
        if segmentCheck.selectedSegmentIndex == 0 {
        let nameOfIntroduce = Notification.Name(rawValue: notificationKey)
        NotificationCenter.default.post(name: nameOfIntroduce, object: nil)

        } else if segmentCheck.selectedSegmentIndex == 1 {
            let nameOfSports = Notification.Name(rawValue: sportsNotificationKey)
            NotificationCenter.default.post(name: nameOfSports, object: nil)
        }
    }
    
    
    @IBAction func switchViews(_ sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            myAccountView.alpha = 1
            myPreferenceSportsView.alpha = 0
        } else {
            myAccountView.alpha = 0
            myPreferenceSportsView.alpha = 1
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    }
}
