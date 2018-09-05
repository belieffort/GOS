//
//  ProfileUserInfoVC.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 27..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import TagListView
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileUserInfoVC: UIViewController, TagListViewDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    @IBOutlet weak var userFollower: UILabel!
    @IBOutlet weak var btnFollowText: UIButton!
    @IBOutlet weak var userIntroduce: UITextView!
    @IBOutlet weak var userInterestSports: TagListView!
    @IBOutlet weak var interestSportsLbl: UILabel!
    
    var userUID = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    
    var ref: DatabaseReference!
    var plans: [DataSnapshot]! = []
    var followingData: [DataSnapshot]! = []
    var followerData: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    var passedEmail:String?
    var anotherUserUID:String?
    var friendTF:Bool!
    var followingUIDArr = [String]()
    var followerUIDArr = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interestSportsLbl.isHidden = true
        userInterestSports.delegate = self
        ref = Database.database().reference()
        getUserUID()
        userEmailLbl.text = passedEmail

        userFollowing.isUserInteractionEnabled = true
        userFollower.isUserInteractionEnabled = true
        userFollowing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followingTapped)))
        userFollower.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followerTapped)))
    }
    
    @objc private func followingTapped(_ recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "FollowingSegue", sender: self)
    }
    @objc private func followerTapped(_ recognizer: UITapGestureRecognizer) {
        performSegue(withIdentifier: "FollowerSegue", sender: self)
    }

    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)}
    }

    func initialFollow() {
        ref.child("Follow").child("Following").child(userUID!).observe(.value, with: { (snapshot) in
            let follow = snapshot.children.allObjects as! [DataSnapshot]
                if (follow != []) {
                    for i in follow {
                        if (i.value as! Bool == true && i.key == self.anotherUserUID!) {
                            self.friendTF = true
                            self.btnFollowText.setTitle("Following", for: .normal)
                            break
                        } else {
                            self.friendTF = false
                            self.btnFollowText.setTitle("Follow", for: .normal)
                        }
                    }
                } else {
                    self.friendTF = false
                    self.btnFollowText.setTitle("Follow", for: .normal)
                }
        })
    }
    
    //TODO - Follow버튼을 눌렀을 때, 레이블에 있는 숫자가 예를 들어 1개에서 3개로 늘어난다.
    func numberOfFollowing() {
        var followingCount = 0
        if userUID != anotherUserUID {
            ref.child("Follow").child("Following").child(anotherUserUID!).observe(.value, with: { (snapshot) in
                let following = snapshot.children.allObjects as! [DataSnapshot]
                if (following != []) {
                    for i in following {
                        if (i.value as! Bool == true) {
                            followingCount += 1
                        } else {
                            //TODO - count -= 1
                        }
                    }
                    self.userFollowing.text = String(followingCount)
                } else {
                    self.userFollowing.text = String(followingCount)
                }
                
            })
         } else {
            ref.child("Follow").child("Following").child(userUID!).observe(.value, with: { (snapshot) in
                let following = snapshot.children.allObjects as! [DataSnapshot]
                if (following != []) {
                    for i in following {
                        if (i.value as! Bool == true) {
                            followingCount += 1
                        } else {
                        }
                    }
                    self.userFollowing.text = String(followingCount)
                } else {
                    self.userFollowing.text = String(followingCount)
                }
                
            })
        }
    }
    
    func numberOfFollower() {
        var followerCount = 0
        if userUID != anotherUserUID {
            ref.child("Follow").child("Follower").child(anotherUserUID!).observe(.value, with: { (snapshot) in
                let follower = snapshot.children.allObjects as! [DataSnapshot]
                if (follower != []) {
                    for i in follower {
                        if (i.value as! Bool == true) {
                            followerCount += 1
                        } else {
                        }
                    }
                    self.userFollower.text = String(followerCount)
                } else {
                    self.userFollower.text = String(followerCount)
                }
                
            })
        } else {
            ref.child("Follow").child("Follower").child(userUID!).observe(.value, with: { (snapshot) in
                let follower = snapshot.children.allObjects as! [DataSnapshot]
                if (follower != []) {
                    for i in follower {
                        if (i.value as! Bool == true) {
                            followerCount += 1
                        } else {
                        }
                    }
                    self.userFollower.text = String(followerCount)
                } else {
                    self.userFollower.text = String(followerCount)
                }
                
            })
        }
    }
    
    @IBAction func btnFollow(_ sender: Any) {
        
        if (friendTF == true) {
            var following = [String:Bool]()
            following = ["\(anotherUserUID!)" : false]
            ref.child("Follow").child("Following").child(userUID!).updateChildValues(following)
            var follower = [String:Bool]()
            follower = ["\(userUID!)" : false]
            ref.child("Follow").child("Follower").child(anotherUserUID!).updateChildValues(follower)
            btnFollowText.setTitle("Follow", for: .normal)
            print("have it")
            friendTF = false
        } else if (friendTF == false)  {
            var following = [String:Bool]()
            following = ["\(anotherUserUID!)" : true]
            ref.child("Follow").child("Following").child(userUID!).updateChildValues(following)
            var follower = [String:Bool]()
            follower = ["\(userUID!)" : true]
            ref.child("Follow").child("Follower").child(anotherUserUID!).updateChildValues(follower)
            btnFollowText.setTitle("Following", for: .normal)
            print("Don't have it")
            friendTF = true
        }
    }
    
    
    func getUserUID() {
        ref.child("Users").queryOrdered(byChild: "email").queryEqual(toValue: passedEmail!).observe(.childAdded, with: {snapshot in
            let writerUID = snapshot.key
            if writerUID != self.passedEmail! {
                self.anotherUserUID = writerUID
                self.showProfileImage()
                self.numberOfFollower()
                self.numberOfFollowing()
                self.getPreferenceSports()
                self.initialFollow()
                self.getIntroduce()
                self.getFollowingUID()

              
            } else {
                print("nope")
                self.showProfileImage()
                self.numberOfFollower()
                self.numberOfFollowing()
                self.getPreferenceSports()
                self.initialFollow()
                self.getIntroduce()
                self.getFollowingUID()

            }
        })
    }
    
    func showProfileImage() {
        if userUID != anotherUserUID {
            ref.child("Users").child(anotherUserUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
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
            ref.child("Users").child(self.userUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
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
    
    func getIntroduce() {
        if self.userUID != self.anotherUserUID {
                ref.child("Users").child(anotherUserUID!).child("Introduce").observe(.value, with: { (snapshot) in
                if let snapDict = snapshot.value as? [String:AnyObject]{
                    self.userIntroduce.text = snapDict["IntroduceText"]  as! String }
                }
            )} else {
                ref.child("Users").child(userUID!).child("Introduce").observe(.value, with: { (snapshot) in
                if let snapDict = snapshot.value as? [String:AnyObject]{
                    self.userIntroduce.text = snapDict["IntroduceText"]  as! String }
                }
            )}
        
    }
    
    func getPreferenceSports() {
        var countBox = [String]()
        if userUID != anotherUserUID {
            _refHandle = ref.child("Users").child("\(anotherUserUID!)").child("PreferenceSports").observe(.childAdded, with: { (snapshot) in
                let sports = snapshot.value as! String
                if sports == "true" {
                    self.userInterestSports.addTag("\(snapshot.key)")
                } else if sports == "false" {
                    countBox.append(sports)
                    if countBox.count == 8 {
                        self.interestSportsLbl.isHidden = false
                    }
                }
            })

        } else {
            _refHandle = ref.child("Users").child("\(userUID!)").child("PreferenceSports").observe(.childAdded, with: { (snapshot) in
                //value 값이 True면 추가
                let sports = snapshot.value as! String
                if sports == "true" {
                    self.userInterestSports.addTag("\(snapshot.key)")
                } else if sports == "false" {
                    countBox.append(sports)
                    if countBox.count == 8 {
                        self.interestSportsLbl.isHidden = false
                        }
                    }
            })
        }
    }
    
    func getFollowingUID() {
        if userUID != anotherUserUID {
            
            ref.child("Follow").child("Following").child(anotherUserUID!).observe(.value, with: { (snapshot) in
                let following = snapshot.children.allObjects as! [DataSnapshot]
                for i in following {
                    if (i.value as! Bool == true) {
                        self.followingUIDArr.append(i.key)
                    }
                }
                self.getFollowingInfo()
            })
            
            ref.child("Follow").child("Follower").child(anotherUserUID!).observe(.value, with: { (snapshot) in
                let following = snapshot.children.allObjects as! [DataSnapshot]
                for i in following {
                    if (i.value as! Bool == true) {
                    self.followerUIDArr.append(i.key)
                    }
                }
                self.getFollowerInfo()
            })
            
            
        } else {
            ref.child("Follow").child("Following").child(userUID!).observe(.value, with: { (snapshot) in
                let following = snapshot.children.allObjects as! [DataSnapshot]
                for i in following {
                    if (i.value as! Bool == true) {
                        self.followingUIDArr.append(i.key)
                    }
                }
                self.getFollowingInfo()

            })
            
            ref.child("Follow").child("Follower").child(userUID!).observe(.value, with: { (snapshot) in
                let following = snapshot.children.allObjects as! [DataSnapshot]
                for i in following {
                    if (i.value as! Bool == true) {
                        self.followerUIDArr.append(i.key)
                    }
                }
                self.getFollowerInfo()
            })
        }
    }
    
    func getFollowingInfo() {
        for i in followingUIDArr {
            ref.child("Users").child(i).observe(.value, with: { (snapshot) in
                self.followingData.append(snapshot)
            })
        }
    }
    
    func getFollowerInfo() {
        for i in followerUIDArr {
            ref.child("Users").child(i).observe(.value, with: { (snapshot) in
                self.followerData.append(snapshot)
            })
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChatRoom" {
            let chatVC = segue.destination as! ChatVC
            chatVC.receiverUID = anotherUserUID!
        } else if segue.identifier == "FollowingSegue" {
            let followingVC = segue.destination as! FollowingVC
            followingVC.followingData = followingData
        } else if segue.identifier == "FollowerSegue" {
            let followerVC = segue.destination as! FollowerVC
            followerVC.followerData = followerData
        }
    }
 

}
