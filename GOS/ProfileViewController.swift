//
//  ProfileViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 15..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//


//TODO - 현재 로그인한 유저의 이메일과 Recruitment에 있는 이메일과 비교해서 동일한 것만 올리게 한다!
import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileID: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    var ref: DatabaseReference!
    var myRecruitment: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    var time = [String]()
    var location = [String]()
    var sportsImage = [UIImage(named: "badminton-1"), UIImage(named: "football-1"), UIImage(named: "basketball-1"), UIImage(named: "hockey-1"), UIImage(named: "tennis-1")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileID.text = Auth.auth().currentUser?.email
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
        let postedEmail = recruitment["UserID"] ?? "[UserID]"
        
        if Auth.auth().currentUser?.email == postedEmail {
            
            cell.scheduleTime.text = recruitment["Time"] ?? "[Time]"
            cell.scheduleLocation.text = recruitment["Location"] ?? "[Location]"
        }
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
            strongSelf.myRecruitment.append(snapshot)
            strongSelf.profileTableView.insertRows(at: [IndexPath(row: strongSelf.myRecruitment.count-1, section: 0)], with: .automatic)
            
            
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
