//
//  ProfilePreferenceSportsVC.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 17..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfilePreferenceSportsVC: UIViewController {
  
    var ref: DatabaseReference!
    var Preference: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userUid = Auth.auth().currentUser?.uid
    
    var delegateVC = ProfilePreferenceSportsCell()
    
    @IBOutlet weak var listOfSports: UITableView!

    var sampleSports = ["Basketball", "Baseball", "Volleyball", "Soccer", "Tennis", "Ice Hockey", "Table Tennis", "Badminton"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateVC.selectionDelegate = self
        ref = Database.database().reference()
        
        let nib = UINib(nibName: "ProfilePreferenceSportsCell", bundle: nil)
        listOfSports.register(nib, forCellReuseIdentifier: "SportsList")
        listOfSports.tableFooterView = UIView()
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

extension ProfilePreferenceSportsVC:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleSports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfSports.dequeueReusableCell(withIdentifier: "SportsList") as! ProfilePreferenceSportsCell
        
        cell.btnSports.setTitle(sampleSports[indexPath.row], for: .normal)
        cell.btnSports.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left

        return cell
    }
    
    //셀을 선택했을 때, 셀의 색상을 결정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        listOfSports.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clear.cgColor
        selectionColor.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectionColor
    }
}

extension ProfilePreferenceSportsVC:SelectionSportsDelegate {
    func didTapSelect(_ sender: UIButton) {
        //TODO - 연결이 안된 것 같다 08/18
        print("Connect Success")
        let btnPosition = sender.convert(sender.bounds.origin, to: listOfSports)
        let indexPath = listOfSports.indexPathForRow(at: btnPosition)
        let rowIndex =  sampleSports[(indexPath?.row)!]
        ref = Database.database().reference()
        ref.child("Users").child("\(userUid!)").child("Preference").setValue("\(rowIndex)")
    }
    
    
    
}
