//
//  ProfileViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 15..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


//TODO - 현재 로그인한 유저의 이메일과 Recruitment에 있는 이메일과 비교해서 동일한 것만 올리게 한다!
//TODO - 회원가입을 한 유저가 로그아웃을 누르면, 회원가입 화면으로 돌아간다. 또한 아이디와 비밀번호가 그대로 있기 때문에, 초기화를 시켜주어야 한다.
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileID: UIButton!
    
    var ref: DatabaseReference!
    var myRecruitment: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userUID = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProfileImage()
        let userID = Auth.auth().currentUser?.email
        profileID.setTitle("\(userID!)", for: .normal)
//        view.addSubview(profileImage)
//        profileImage.layer.cornerRadius = 60
//        profileImage.layer.masksToBounds = true
        configureDatabase()
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            print("로그아웃 되었습니다.")
        } catch {
            print("Logout Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecruitment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        
        let recruitmentSnapshot: DataSnapshot! = self.myRecruitment[indexPath.row]
        guard let recruitment = recruitmentSnapshot.value as? [String:String] else {return cell }
        
            cell.myScheduleTime.text = recruitment["Time"] ?? "[Time]"
            cell.myScheduleLocation.text = recruitment["Location"] ?? "[Location]"
        
        return cell
    }

    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Recruitment").removeObserver(withHandle: refHandle)}
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
            _refHandle = self.ref.child("Recruitment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            
            let writerSnapshot: DataSnapshot! = snapshot
            guard let writerEmail = writerSnapshot.value as? [String:String] else { return }
            let writer = writerEmail["Writer"]
                if writer == self?.userEmail! {
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
                        print(error)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
