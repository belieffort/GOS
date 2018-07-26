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
    
    
    var userNumber:String?
    var userNumberBox:String?
    var userNumberConvert:Int?
    var userArrayBox:[Int] = []
    var userLikeitCount:String?
    var userLikeitCountConvert:Int?
    var userValueArray:[String] = []
    var writeNumber:String?
//    var writeNumberBox:String!
    var writeNumberCount:String?
    var writeNubmerConvert:Int?
    var writeArray:[String] = []
    var testingBox:String!
    
    
    //===================================
    
    var totalBox:[String] = []
    var totalNumber:String?
    var uid = Auth.auth().currentUser?.uid
    var numberOfLikeit:String?
    var escapedCallbacks: [() -> ()] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        LIkeit 안에 있는 child 총 개수를 구한다.
            Database.database().reference().child("Users").child(self.uid!).child("Likeit").observeSingleEvent(of: .value, with: {(snap) in
            self.numberOfLikeit = "\(snap.childrenCount)"
            print("문자inner \(self.numberOfLikeit!)")
        })
//        print("문자outer \(self.numberOfLikeit!)")

//        child 총 개수를 통해 For문을 작성하여 tableview에 출력되어야 할 총 row를 배열안에 넣는다.
//        if let boxGroupArray = Int(self.numberOfLikeit!) {
//            for i in 0..<boxGroupArray  {
//                Database.database().reference().child("Users").child(self.uid!).child("Likeit").child("Index\(i)").observeSingleEvent(of: .value, with: {(snap) in
//                    let dump = snap.value as? String
//                    self.userValueArray.append(dump!)
//                    print(self.userValueArray)
//                })
//            }
//        
//        }
    }
        
        //Recruitment에 있는 총 게시글의 개수를 가져온다.
//        Database.database().reference().child("Recruitment").observeSingleEvent(of: .value, with: {(snap) in
//            self.writeNumberCount = "\(snap.childrenCount)"
//
//            Database.database().reference().child("Users").child(self.uid!).child("Likeit").observeSingleEvent(of: .value, with: {(snap) in
//                self.userLikeitCount = "\(snap.childrenCount)"
//                //            print("문자inner \(self.userLikeitCount!)")
//                if let boxGroupArray = Int(self.userLikeitCount!) {
//                    for i in 0..<boxGroupArray  {
//                        Database.database().reference().child("Users").child(self.uid!).child("Likeit").child("Index\(i)").observeSingleEvent(of: .value, with: {(snap) in
//                            let dump = snap.value as? String
//                            self.userValueArray.append(dump!)
//                            print(self.userValueArray)
//
//                        })
//                    }
//
//                }
//            })
//        })
        
        //Users-uid-Likeit에 있는 총 index개수를 가져온다.
//        Database.database().reference().child("Users").child(uid!).child("Likeit").observeSingleEvent(of: .value, with: {(snap) in
//            self.userLikeitCount = "\(snap.childrenCount)"
////            self.userLikeitCountConvert = Int(self.userLikeitCount!)
////            print("문자inner \(self.userLikeitCount!)")
//            if let boxGroupArray = Int(self.userLikeitCount!) {
//                for i in 0..<boxGroupArray  {
//                    Database.database().reference().child("Users").child(self.uid!).child("Likeit").child("Index\(i)").observeSingleEvent(of: .value, with: {(snap) in
//                        let dump = snap.value as? String
//                        self.userValueArray.append(dump!)
//                        print(self.userValueArray)
//
//                    })
//                }
//
//            }
//        })

        //User에 있는 Index에 갖고 있는 값을 갖고 온다.
        //TODO - 왜 userLikeitCountCovert에 들어있는 Int값은 안되는 것일까...?
//        let exampleTwo = 1
//        if let boxGroupArray = Int(userLikeitCount!) {
//            for i in 0..<boxGroupArray  {
//                Database.database().reference().child("Users").child(uid!).child("Likeit").child("Index\(i)").observeSingleEvent(of: .value, with: {(snap) in
//                    let dump = snap.value as? String
//                    self.userValueArray.append(dump!)
//                    print(self.userValueArray)
//
//                })
//            }
//
//        }
       
        
        
//TODO - userNumber는 빈 변수이다. userNumber에 현재 로그인한 userd의 likeit-Index를 넣어주어야 한다.
//        ref.child("Users").child(uid!).child("Likeit").child("Index\(userNumber!)").observe(.value, with: { (snapshot) in
//
//            let userNumberBox = snapshot.value as? String
//            print(userNumberBox ?? "userNumberBox")
//        })
    
//        configureDatabase()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalBox.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IlikeCell", for: indexPath) as! FavoriteTableViewCell

      
//        let userLikeSnapshot: DataSnapshot! = self.userLikeit[indexPath.row]
//        guard let ilikeit = userLikeSnapshot.value as? [String:String] else {return cell }
        
        //Recruitment에 있는 총 게시글의 개수를 가져온다.
//        Database.database().reference().child("Recruitment").observeSingleEvent(of: .value, with: {(snap) in
//            self.writeNumberCount = "\(snap.childrenCount)"
//            print("\(self.writeNumberCount!)")
//        })
        
        
        
//        Database.database().reference().child("Users").child(self.uid!).child("Likeit").observeSingleEvent(of: .value, with: {(snap) in
//            self.userLikeitCount = "\(snap.childrenCount)"
//            print("문자inner \(self.userLikeitCount!)")
//            if let boxGroupArray = Int(self.userLikeitCount!) {
//                for i in 0..<boxGroupArray  {
//                    Database.database().reference().child("Users").child(self.uid!).child("Likeit").child("Index\(i)").observeSingleEvent(of: .value, with: {(snap) in
//                        let dump = snap.value as? String
//                        self.userValueArray.append(dump!)
//                        print("유저가 누른 Like 수 \(self.userValueArray)")
//
//                    })
//                }
//            }
//        })
        
        
        
        
//                            if let writeNumberArray = Int(self.writeNumberCount!){
//                                for b in 0..<writeNumberArray {
//                                    Database.database().reference().child("Recruitment").child("\(b)").child("WriteNumber").observeSingleEvent(of: .value, with: { (snap) in
//                                        let writeDump = snap.value as? String
//                                        self.writeArray.append(writeDump!)
//                                        print("총 게시글의 수 \(self.writeArray)")
//
//                                    })
//                                }
//                            }

        
        
        
//        //Recruitment에 있는 총 게시글의 수를 돌면서
//        for i in  0..<(writeNumberArray) {
//            Database.database().reference().child("Recruitment").child("\(i)").child("WriteNumber").observeSingleEvent(of: .value, with: { (snap) in
//                self.testingBox = snap.value as? String
//
//                //Likeit-User에 있는 Index숫자와 Recruitment에 있는 WriteNumber와 동일하다면 다음과 같은 셀을 추가한다.
//                if self.userNumberBox == self.testingBox {
//                    //TODO - Recruitment에 있는 데이터를 갖고 와서 넣어준다.
//                    cell.likeTime.text = ilikeit["Time"] ?? "[Time]"
//                    cell.likeLocation.text = ilikeit["Location"] ?? "[Location]"
//                    cell.likePeople.text = ilikeit["numberOfPeople"] ?? "[numberOfPeople]"
//                }
//            })
//
//
//        }
        
        
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
