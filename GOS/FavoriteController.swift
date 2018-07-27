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
    
    var uid = Auth.auth().currentUser?.uid
    var numberOfLikeit = [String:AnyObject]()
    var numberOfWrite = [String:AnyObject]()
    var userLikeitArray:[String] = []
    var recruitmentKeyArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureDatabase()
        
        Database.database().reference().child("Users").child(self.uid!).child("Likeit").observeSingleEvent(of: .value, with: {(UserKeysnapshot) in
            if UserKeysnapshot.exists() {
                self.numberOfLikeit = UserKeysnapshot.value! as! [String : AnyObject]
                self.getUserLikeitArray(snapshot: self.numberOfLikeit)
            }
        })
        
        Database.database().reference().child("Recruitment").observeSingleEvent(of: .value, with: {(WritekeySnapshot) in
            if WritekeySnapshot.exists() {
                self.numberOfWrite = WritekeySnapshot.value! as! [String: AnyObject]
                self.getWriteKeyArray(snapshot: self.numberOfWrite)
            }
        })
        
        samplePrint()
        
        
//        LIkeit 안에 있는 child 총 개수를 구한다. 단, 배열 형태로 구해야 한다.
//        Database.database().reference().child("Users").child(self.uid!).child("Likeit").observeSingleEvent(of: .value, with: {(Snapshot) in
//            if let snapDict = Snapshot.value as? [String:AnyObject]{
//                for each in snapDict{
//                    self.numberOfLikeit.append(each.value as! String)
//                    print("numberOfLikeit \(self.numberOfLikeit)")
//                }
//            }
//        })
        
        
//        Recruitment 안에 있는 child 총 개수를 구한다. 단, 배열 형태로 구해야 한다.
//        Database.database().reference().child("Recruitment").observeSingleEvent(of: .value, with: {(Snapshot) in
//            if let snapDict = Snapshot.value as? [String:AnyObject]{
//                for new in snapDict{
//                    self.recruitmentKeyArray.append(new.key)
//                    print("numberOfLikeit \(recruitmentKeyArray)")
//                }
//            }
//        })
        
    }
    
    func getUserLikeitArray(snapshot: [String:AnyObject]) {
        //data is here
            for each in numberOfLikeit {
                self.userLikeitArray.append(each.value as! String)
            }
//        print("outer numberOfLikeit \(self.userLikeitArray)")
//        print(self.userLikeitArray.count)
    }
    
    func getWriteKeyArray(snapshot: [String:AnyObject]) {
            for new in numberOfWrite{
                self.recruitmentKeyArray.append(new.key)
        }
//        print("outer recruitmentKeyArray \(self.recruitmentKeyArray)")
//        print(self.recruitmentKeyArray.count)
    }
    
    //TODO - userLikeitArray와 recruitmentKeyArray를 비교하여 공통된 요소로 구성된 배열을 만든다.
    func samplePrint() {
        
        var someHash: [String: Bool] = [:]
        
        recruitmentKeyArray.forEach { someHash[$0] = true }
        
        var commonItems = [String]()
        
        userLikeitArray.forEach { veg in
            if someHash[veg] ?? false {
                commonItems.append(veg)
            }
        }
        
        print(commonItems)
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfLikeit.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IlikeCell", for: indexPath) as! FavoriteTableViewCell
        

        return UITableViewCell()
    }

    
//    deinit {
//        if let refHandle = _refHandle {
//            self.ref.child("Recruitment").removeObserver(withHandle: refHandle)
//        }
//    }
//
//    func configureDatabase() {
//        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
//        _refHandle = self.ref.child("Recruitment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//            guard let strongSelf = self else { return }
//            strongSelf.userLikeit.append(snapshot)
//            strongSelf.likeTableView.insertRows(at: [IndexPath(row: strongSelf.userLikeit.count-1, section: 0)], with: .automatic)
//        })
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
}
