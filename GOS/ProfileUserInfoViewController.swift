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
        interestLbl.isHidden = true
        ref = Database.database().reference()
        getUserUID()
        getUserPlan()
        getUserImageURL()
        userInterestSports.delegate = self
        userEmail.text = passEmail
    }
    
    func initialFollow() {
 
        ref.child("Users").child("\(userUid!)").child("friends").observe(.value, with: { (snapshot) in
            let friend = snapshot.children.allObjects as! [DataSnapshot]
            //여러개의 Value를 갖고 있다면 결국 T/F는 작동하기 어려운 듯! 왜냐하면 계속 반복하니까
            //friends + AutoKey + UID:true
            //Break로 해결!!
            if (friend != []) {
                for i in friend {
                    if (i.value as! Bool == true && i.key == self.anotherUserUID!) {
                        self.friendTF = true
                        self.followText.setTitle("Following", for: .normal)
                        break
                    } else {
                        self.friendTF = false
                        self.followText.setTitle("Follow", for: .normal)
                    }
                }
            } else {
                self.friendTF = false
                self.followText.setTitle("Follow", for: .normal)
            }
        })
    }

    @IBAction func btnfollow(_ sender: Any) {
        
        if (friendTF == true) {
            var friendData = [String:Bool]()
            friendData = ["\(anotherUserUID!)": false]
            ref.child("Users").child("\(userUid!)").child("friends").updateChildValues(friendData)
            followText.setTitle("Follow", for: .normal)
            print("have it")
            friendTF = false

        } else if (friendTF == false)  {
            var friendData = [String:Bool]()
            friendData = ["\(anotherUserUID!)": true]
            ref.child("Users").child("\(userUid!)").child("friends").updateChildValues(friendData)
            followText.setTitle("Following", for: .normal)
            print("Don't have it")
            friendTF = true

        }
        
    }
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)}
    }
    
    func getUserPlan() {
           _refHandle = self.ref.child("Users").child("\(passUID!)").child("Join")
                .observe(.childAdded, with: { [weak self] (snapshot) in
                    guard let strongSelf = self else { return }
                    strongSelf.plans.append(snapshot)
                    strongSelf.userPlainTableView.insertRows(at: [IndexPath(row: strongSelf.plans.count-1, section: 0)], with: .automatic)
            })
    }
    
    func getPreferenceSports() {
        var countBox = [String]()
        if userUid != anotherUserUID {
            _refHandle = ref.child("Users").child("\(anotherUserUID!)").child("PreferenceSports").observe(.childAdded, with: { (snapshot) in
                let sports = snapshot.value as! String
                if sports == "true" {
                    self.userInterestSports.addTag("\(snapshot.key)")
                } else if sports == "false" {
                    countBox.append(sports)
                    if countBox.count == 8 {
                        self.interestLbl.isHidden = false
                    }
                }
            })
            
        } else {
            _refHandle = ref.child("Users").child("\(userUid!)").child("PreferenceSports").observe(.childAdded, with: { (snapshot) in
                //value 값이 True면 추가
                let sports = snapshot.value as! String
                if sports == "true" {
                    self.userInterestSports.addTag("\(snapshot.key)")
                } else if sports == "false" {
                    countBox.append(sports)
                    if countBox.count == 8 {
                        self.interestLbl.isHidden = false
                        }
                    }
                })
        }
    }
    
    func getUserUID() {
        ref = Database.database().reference()
        ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: passEmail!).observe(.childAdded, with: {snapshot in
            let writerUID = snapshot.key
            if writerUID != self.passEmail! {
                self.anotherUserUID = writerUID
                self.showProfileImage()
                self.getPreferenceSports()
                self.initialFollow()

            } else {
                print("nope")
                self.showProfileImage()
                self.getPreferenceSports()
                self.initialFollow()

            }
        })
    }
    
    func getUserImageURL() {
        
        ref.child("Users").child(userUid!).child("profileImage").observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInfo = snapshot.value as? String {
                self.userImageURL = userInfo
            } else {
            }
        })
    }
    
    func showProfileImage() {
        if userUid != anotherUserUID {
            Database.database().reference().child("Users").child(anotherUserUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
                if let url = snapshot.value as? String {
                    URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                        
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self.userImage.image = image
                        }
                        }.resume()
                    }
                })
        } else {
            Database.database().reference().child("Users").child(self.userUid!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
                if let url = snapshot.value as? String {
                    URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                        
                        if error != nil {
                            print(error as Any)
                            return
                        }
                        DispatchQueue.main.async {
                            let image = UIImage(data: data!)
                            self.userImage.image = image
                            
                        }
                        }.resume()
                    }
                })
            }
        }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatRoom" {
            let chatVC = segue.destination as! ChatVC
            chatVC.receiverUID = passUID!
        }
    }
}

extension ProfileUserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userPlainTableView.dequeueReusableCell(withIdentifier: "UserPlanCell", for: indexPath) as! ProfileUserPlanTableViewCell
        
        let userSnapshot: DataSnapshot! = self.plans[indexPath.row]
        guard let plan = userSnapshot.value as? [String:AnyObject] else { return cell }
        
        let title = plan["Title"] as? String
        let location = plan["Location"] as? String
        let time = plan["Time"] as? String
        
        cell.userPlan_Title.text = title
        cell.userPlan_Location.text = location
        cell.userPlan_Time.text = time
        
        return cell
    }
}
