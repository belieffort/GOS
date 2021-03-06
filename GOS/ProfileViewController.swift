//
//  ProfileViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 15..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

let deleteNotificationKey = "co.dbh.btndelete"


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileID: UIButton!
    
    var ref: DatabaseReference!
    var myRecruitment: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userUID = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    
    let delete = Notification.Name(rawValue: deleteNotificationKey)

    var deleteIndex:IndexPath!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        profileTableView.endUpdates()
        showProfileImage()
        configureDatabase()
        profileID.setTitle("\(userEmail!)", for: .normal)
        creatObservers()

     }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        if let refHandle = _refHandle {
            self.ref.child("Recruitment").removeObserver(withHandle: refHandle)
            self.ref.child("Users").removeObserver(withHandle: refHandle)
        }
    }
    
    func creatObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.deleteData(notification:)), name: delete, object: nil)
    }
    
    @objc func deleteData(notification: Notification) {
        myRecruitment.remove(at: deleteIndex.row)
        profileTableView.deleteRows(at: [deleteIndex], with: .fade)
        profileTableView.reloadData()
    }
    
   

    @IBAction func btnLogout(_ sender: Any) {
        //TODO - 회원가입을 한 유저가 로그아웃을 누르면, 회원가입 화면으로 돌아간다. 또한 아이디와 비밀번호가 그대로 있기 때문에, 초기화를 시켜주어야 한다.
        do {
            try Auth.auth().signOut()
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            print("로그아웃 되었습니다.")
        } catch {
            print("Logout Failed")
        }
    }
    
 
    
    func configureDatabase() {
        // Listen for new messages in the Firebase database
        profileTableView.beginUpdates()
            _refHandle = self.ref.child("Recruitment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }

            let writerSnapshot: DataSnapshot! = snapshot
            guard let writerEmail = writerSnapshot.value as? [String:AnyObject] else { return }
            let writer = writerEmail["WriterEmail"]
                if writer! as! String == self!.userEmail! {
                        strongSelf.myRecruitment.append(snapshot)
                        strongSelf.profileTableView.insertRows(at: [IndexPath(row: strongSelf.myRecruitment.count-1, section: 0)], with: .automatic)
            }
        })

        
    }
    
    func showProfileImage() {

        Database.database().reference().child("Users").child(self.userUID!).child("profileImage").observeSingleEvent(of: .value, with: { snapshot in
            if let url = snapshot.value as? String {
                URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                    
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    DispatchQueue.main.async {
                        let image = UIImage(data: data!)
                        self.profileImage.image = image
                    }
                }.resume()
            }
        })
    }
    // TODO - Cell 삭제 기능이 필요하다.
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "MyWriteDetail" {
            let myWriteDetail: DataSnapshot! = self.myRecruitment[profileTableView.indexPathForSelectedRow!.row]
            guard let writeDetail = myWriteDetail.value as? [String:AnyObject] else { return }
            
            let myScheduleDetailViewController = segue.destination as! MyScheduleDetailViewController
            myScheduleDetailViewController.my_userID = writeDetail["WriterEmail"] as? String
            myScheduleDetailViewController.my_titleBox = writeDetail["Title"] as? String
            myScheduleDetailViewController.my_time = writeDetail["Time"] as? String
            myScheduleDetailViewController.my_location = writeDetail["Location"] as? String
            myScheduleDetailViewController.my_people = writeDetail["NumberOfPeople"] as? String
            myScheduleDetailViewController.my_position = writeDetail["Position"] as? String
            myScheduleDetailViewController.my_notice = writeDetail["Detail"] as? String
            myScheduleDetailViewController.my_sports = writeDetail["Sports"] as? String
            myScheduleDetailViewController.passedSelectedIndexpath = self.myRecruitment[profileTableView.indexPathForSelectedRow!.row]
            myScheduleDetailViewController.postAutokey = myWriteDetail.key
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        deleteIndex = indexPath
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecruitment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell

        let recruitmentSnapshot: DataSnapshot! = self.myRecruitment[indexPath.row]
        guard let recruitment = recruitmentSnapshot.value as? [String:AnyObject] else {return cell }
        
        cell.myScheduleTime.text = recruitment["Time"] as! String
        cell.myScheduleLocation.text = recruitment["Location"] as! String

        return cell
    }
}
