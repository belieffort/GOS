//
//  HomeViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 13..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

let deleteAtHomeKey = "co.dbh.delete"

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarControllerDelegate {
    var likePostAutoKeyArr = [String]()
    var falsePostAutoKeyArr = [String]()

    var postDataSnapshot: [DataSnapshot]! = []
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    var ref: DatabaseReference!
    var recruitment: [DataSnapshot]! = []
    var keysnap: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userUID = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    
    var seletedCollectionViewCell:IndexPath?
    var sportsImageNameBox = ["Basketball","Soccer","Volleyball","Tennis","Baseball","Badminton","Table Tennis","Ice Hockey"]
    
    let delete = Notification.Name(rawValue: deleteAtHomeKey)
    
    var testValue:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        configureDatabase()
        testFunc()
        self.tabBarController?.delegate = self
        getLikePostKey()
        creatObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Count?")
    }
    

    func creatObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.deleteData(notification:)), name: delete, object: nil)
    }
    
    @objc func deleteData(notification: Notification) {
        print("hello")
     }
    
     //탭바 클릭했을 때,
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            let viewController  = tabBarController.viewControllers?[1] as! UINavigationController
            let controller = viewController.topViewController as! FavoriteController
            controller.postDataSnapshot = postDataSnapshot
        }
    }

    func getLikePostKey() {
         _refHandle = ref.child("Users").child(userUID!).child("LikePost").observe(.value, with: { (snapshot) in
            let likeTF = snapshot.children.allObjects as! [DataSnapshot]
            //Mark: - 배열 초기화
            self.likePostAutoKeyArr = []
            
            for i in likeTF {
                if (i.value as! Bool) == true {
                    self.likePostAutoKeyArr.append(i.key)
                }
            }
            self.getPostData()
        })
    }

    func getPostData() {
        //Mark: - 배열 초기화
        self.postDataSnapshot = []
        
        for i in likePostAutoKeyArr {
            _refHandle = ref.child("Recruitment").child(i).observe(.value, with: { (snapshot) in
                if (snapshot.childrenCount == 0) {
                    self.ref.child("Users").child(self.userUID!).child("LikePost").child(i).removeValue()
                } else {
                    self.postDataSnapshot.append(snapshot)
                }
            })
        }
    }

    //셀 클릭했을 때, 이동할 수 있게 해준다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seletedCollectionViewCell = indexPath
        performSegue(withIdentifier: "MainDetailSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(recruitment.count)
        return recruitment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recruitCell", for: indexPath) as! RecruitCellCollectionViewCell

        let recruitmentSnapshot: DataSnapshot! = self.recruitment[indexPath.row]
        guard let recruit = recruitmentSnapshot.value as? [String:AnyObject] else { return cell }
  
        let sportsBox:AnyObject = recruit["Sports"]!
        if sportsImageNameBox.contains(sportsBox as! String) {
            cell.playImages.image = UIImage(named: "\(sportsBox).jpg")
        }

        let time = recruit["Time"] ?? "[Time]" as AnyObject
        let location = recruit["Location"] ?? "[Location]" as AnyObject
        let numberOfPeople = recruit["NumberOfPeople"] ?? "[numberOfPeople]" as AnyObject

        cell.playSchedule.text = time as? String
        cell.playLocation.text = location as? String
        cell.recruitPerson.text = numberOfPeople as? String
        
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height:1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.opacity = 1.0
        cell.layer.masksToBounds = true
        cell.layer.shadowPath =
            UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        if let refHandle = _refHandle {
            self.ref.child("Recruitment").removeObserver(withHandle: refHandle)
            self.ref.child("Users").removeObserver(withHandle: refHandle)}
    }

    
    func configureDatabase() {
        print("check1")
            _refHandle = self.ref.child("Recruitment")
                .observe(.childAdded, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.recruitment.append(snapshot)
                strongSelf.homeCollectionView.insertItems(at: [IndexPath(row: strongSelf.recruitment.count-1, section: 0)])
            })
    }

    //어떤 데이터를 넘겨줄 것인지
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recruitmentSnapshot: DataSnapshot! = self.recruitment[seletedCollectionViewCell!.item]

        guard let recruit = recruitmentSnapshot.value as? [String:AnyObject] else
        {return print("!!!!!!!!!!!!!!!!!error!!!!!!!!!!!!!!!!!") }

        let detailViewController = segue.destination as! DetailViewController
        detailViewController.userID = recruit["WriterEmail"] as? String
        detailViewController.titleBox = recruit["Title"] as? String
        detailViewController.time = recruit["Time"] as? String
        detailViewController.location = recruit["Location"] as? String
        detailViewController.people = recruit["NumberOfPeople"] as? String
        detailViewController.position = recruit["Position"] as? String
        detailViewController.notice = recruit["Detail"] as? String
        detailViewController.sports = recruit["Sports"] as? String
        //Post의 Auto Key
        detailViewController.postAutokey = recruitmentSnapshot.key
    }
    
}
