//
//  ScheduleViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 13..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase

class FavoriteController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var likeTableView: UITableView!
    @IBOutlet weak var scheduleview_Schedule: UILabel!
    @IBOutlet weak var schedule_Location: UILabel!
    @IBOutlet weak var schedule_Person: UILabel!
    
    var ref: DatabaseReference!
    var userLikeit: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    var writeInfo: [DataSnapshot]! = []

    
    var uid = Auth.auth().currentUser?.uid
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLikeitArray()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLikeit.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userLikeCell", for: indexPath) as! FavoriteTableViewCell
     
        
        //큰 틀을 HomeViewController와 동일하게 만들고, 그 안에서 함수를 배치시켜보기!!
        let likeitSnapshot: DataSnapshot! = self.userLikeit[indexPath.row]
        guard let userLike = likeitSnapshot.value as? [String:String] else { return cell }
        
        let time = userLike["Time"] ?? "[Time]"
        let location = userLike["Location"] ?? "[Location]"
        let numberOfPeople = userLike["NumberOfPeople"] ?? "[numberOfPeople]"

        cell.likeTime.text = time
        cell.likeLocation.text = location
        cell.likePeople.text = numberOfPeople
        
  
        return cell
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)
        }
    }
    
    func getUserLikeitArray() {
        ref = Database.database().reference()
        _refHandle = self.ref.child("Users").child(self.uid!).child("Likeit").observe(.childAdded, with: { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                strongSelf.userLikeit.append(snapshot)
                strongSelf.likeTableView.insertRows(at: [IndexPath(row: strongSelf.userLikeit.count-1, section: 0)], with: .automatic)
        })
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
