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
    @IBOutlet weak var scheduleview_Schedule: UILabel!
    @IBOutlet weak var schedule_Location: UILabel!
    @IBOutlet weak var schedule_Person: UILabel!
    

    var ref: DatabaseReference!
    var userLikeit: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var keyBox:String?
    var uid = Auth.auth().currentUser?.uid
    var seletedTableViewCell:IndexPath!
    var keyOfUserLike:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likeTableView.tableFooterView = UIView()
        getUserLikeitArray()
    }

    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)
        }
    }
    
    func getUserLikeitArray() {
        ref = Database.database().reference()
        _refHandle = self.ref.child("Users").child(self.uid!).child("Likeit")
            //TODO - DetailVC에서 버튼으로 likeit이 제거된 Post는 뷰에서 바로 적용이 안된다.
            .observe(.childAdded, with: { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                strongSelf.userLikeit.append(snapshot)
                strongSelf.likeTableView.insertRows(at: [IndexPath(row: strongSelf.userLikeit.count-1, section: 0)], with: .automatic)

        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let userLikeSnapshot: DataSnapshot! = self.userLikeit[likeTableView.indexPathForSelectedRow!.row]
        guard let likeData = userLikeSnapshot.value as? [String:String] else { return }
        
        // TODO - Recruitment의 child name을 찾으면 된다!!
        let likeDetailViewController = segue.destination as! LikeDetailViewController
        likeDetailViewController.like_userId = likeData["WriterEmail"] ?? "[WriterEmail]"
        likeDetailViewController.like_titleBox = likeData["Title"] ?? "[Title]"
        likeDetailViewController.like_time = likeData["Time"] ?? "[Time]"
        likeDetailViewController.like_location = likeData["Location"] ?? "[Location]"
        likeDetailViewController.like_people = likeData["NumberOfPeople"] ?? "[NumberOfPeople]"
        likeDetailViewController.like_position = likeData["Position"] ?? "[Position]"
        likeDetailViewController.like_notice = likeData["Detail"] ?? "[Detail]"
        likeDetailViewController.like_sports = likeData["Sports"] ?? "[Sports]"
        
        let keySnapshot: DataSnapshot! = self.userLikeit[likeTableView.indexPathForSelectedRow!.row]
        keyOfUserLike = keySnapshot.key
        likeDetailViewController.keyOfUserLike = keyOfUserLike

    }
}

extension FavoriteController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "LikeDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLikeit.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userLikeCell", for: indexPath) as! FavoriteTableViewCell
        
        let likeitSnapshot: DataSnapshot! = self.userLikeit[indexPath.row]
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
        let deleteSnap : DataSnapshot = self.userLikeit[indexPath.row]
        keyBox = deleteSnap.key
        print(keyBox!)
        
        let deleteRef = Database.database().reference().child("Users").child(uid!).child("Likeit").child("\(keyBox!)")
        
        if editingStyle == .delete {
            
            deleteRef.removeValue()
            userLikeit.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
    }
    
    
}



