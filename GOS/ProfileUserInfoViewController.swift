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
   
    
    var ref: DatabaseReference!
    var plan: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?

    
    @IBOutlet weak var userPlan: UITableView!
    @IBOutlet weak var userImage:UIImageView!
    @IBOutlet weak var userEmail:UILabel!
    @IBOutlet weak var userInterestSports: TagListView!
    
    var passEmail:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInterestSports.delegate = self
        userInterestSports.addTag("Basketball")
        userInterestSports.addTag("Ice Hockey")
        userInterestSports.addTag("Volleyball")
        userInterestSports.addTag("Tennis")

    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ProfileUserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
