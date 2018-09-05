//
//  ScheduleViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 13..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FavoriteController: UIViewController {
    
    @IBOutlet weak var likeTableView: UITableView!
    var ref: DatabaseReference!
    var userLikeit: [DataSnapshot]! = []
    var postDataSnapshot: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userUID = Auth.auth().currentUser?.uid
    var keyBox:String!
    var seletedTableViewCell:IndexPath!
    var postAutokey:String?
    
    var likePostAutoKeyArr = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeTableView.tableFooterView = UIView()
        ref = Database.database().reference()
//        print(postDataSnapshot)
    }
    override func viewDidAppear(_ animated: Bool) {
        likeTableView.reloadData()
    }
    
    deinit {

        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let userLikeSnapshot: DataSnapshot! = self.postDataSnapshot[likeTableView.indexPathForSelectedRow!.row]
        guard let likeData = userLikeSnapshot.value as? [String:AnyObject] else { return }
        
        // TODO - Recruitment의 child name을 찾으면 된다!!
        let likeDetailViewController = segue.destination as! LikeDetailViewController
        likeDetailViewController.like_userId = likeData["WriterEmail"] as? String
        likeDetailViewController.like_titleBox = likeData["Title"] as? String
        likeDetailViewController.like_time = likeData["Time"] as? String
        likeDetailViewController.like_location = likeData["Location"] as? String
        likeDetailViewController.like_people = likeData["NumberOfPeople"] as? String
        likeDetailViewController.like_position = likeData["Position"] as? String
        likeDetailViewController.like_notice = likeData["Detail"] as? String
        likeDetailViewController.like_sports = likeData["Sports"] as? String
        
        let keySnapshot: DataSnapshot! = self.postDataSnapshot[likeTableView.indexPathForSelectedRow!.row]
        postAutokey = keySnapshot.key
        likeDetailViewController.postAutokey = postAutokey
        
    }
//    func getLikePostKey() {
//        ref.child("Users").child(userUID!).child("LikePost").observe(.value, with: { (snapshot) in
//            let likeTF = snapshot.children.allObjects as! [DataSnapshot]
//            for i in likeTF {
//                if (i.value as! Bool) == true {
//                    self.likePostAutoKeyArr.append(i.key)
//                    print(self.likePostAutoKeyArr)
//                }
//            }
//            self.getPostData()
//        })
//    }
//
//    func getPostData() {
//        for i in likePostAutoKeyArr {
//            ref.child("Recruitment").child(i).observe(.value, with: { (snapshot) in
//                self.postDataSnapshot.append(snapshot)
////                print(self.postDataSnapshot)
//            })
//        }
//    }
    
//    func getUserLikeitArray() {
//        _refHandle = self.ref.child("Users").child(self.userUID!).child("LikePost")
//            //TODO - DetailVC에서 버튼으로 likeit이 제거된 Post는 뷰에서 바로 적용이 안된다.
//            .observe(.childAdded, with: { [weak self] (snapshot) in
//                guard let strongSelf = self else { return }
//                strongSelf.userLikeit.append(snapshot)
//                strongSelf.likeTableView.insertRows(at: [IndexPath(row: strongSelf.userLikeit.count-1, section: 0)], with: .automatic)
//
//        })
//    }
    
}

extension FavoriteController:UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "LikeDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDataSnapshot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userLikeCell", for: indexPath) as! FavoriteTableViewCell
        
        let likeitSnapshot: DataSnapshot! = self.postDataSnapshot[indexPath.row]
        guard let userLike = likeitSnapshot.value as? [String:AnyObject] else { return cell }
        
        let time = userLike["Time"] as? String
        let location = userLike["Location"] as? String
        let numberOfPeople = userLike["NumberOfPeople"] as? String
                
        cell.likeTime.text = time
        cell.likeLocation.text = location
        cell.likePeople.text = numberOfPeople
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let deleteSnap : DataSnapshot = self.postDataSnapshot[indexPath.row]
        keyBox = deleteSnap.key
        print(keyBox!)
        
        let deleteRef = Database.database().reference().child("Users").child(userUID!).child("LikePost").child("\(keyBox!)")
        
        if editingStyle == .delete {
            
            deleteRef.removeValue()
            postDataSnapshot.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
}



