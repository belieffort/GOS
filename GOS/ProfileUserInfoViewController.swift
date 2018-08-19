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
    var plans: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?

    @IBOutlet weak var userPlainTableView:UITableView!
    @IBOutlet weak var userImage:UIImageView!
    @IBOutlet weak var userEmail:UILabel!
    @IBOutlet weak var userInterestSports: TagListView!

    var passEmail:String!
    var passUID:String!
    var passKeyBox:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
        userInterestSports.delegate = self
        userInterestSports.addTag("Basketball")
        userInterestSports.addTag("Ice Hockey")
        userInterestSports.addTag("Volleyball")
        userInterestSports.addTag("Tennis")
        
        userEmail.text = passEmail
        
//        print(passKeyBox)

    }
    
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)}
    }
    
    func configureDatabase() {
        userPlainTableView.beginUpdates()
    
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("Users").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
                strongSelf.plans.append(snapshot)
                strongSelf.userPlainTableView.insertRows(at: [IndexPath(row: strongSelf.plans.count-1, section: 0)], with: .automatic)
            }
        )}
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

extension ProfileUserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userPlainTableView.dequeueReusableCell(withIdentifier: "UserPlanCell", for: indexPath) as! ProfileUserPlanTableViewCell
        
        let userSnapshot: DataSnapshot! = self.plans[indexPath.row]
        guard let plan = userSnapshot.value as? [String:String] else { return cell }
        
        
        cell.userPlan_Title.text = plan["Title"] ?? "[Title]"
        cell.userPlan_Location.text = plan["Location"] ?? "[Location]"
        cell.userPlan_Time.text = plan["Time"] ?? "[Time]"

        
//        if let url = plan["UserProfileImage"] {
//            URLSession.shared.dataTask(with: URL(string: url as! String)!) { data, response, error in
//
//                if error != nil {
//                    print(error as Any)
//                    return
//                }
//                DispatchQueue.main.async {
//                    let image = UIImage(data: data!)
//                    cell.reply_UserImage.image = image
//                }
//                }.resume()
//        }
        return cell
    }
}
