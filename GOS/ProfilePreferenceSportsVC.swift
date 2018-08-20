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

let sportsNotificationKey = "co.dbh.sportsDone"

class ProfilePreferenceSportsVC: UIViewController {
  
    var ref: DatabaseReference!
    var Preference: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    var userUID = Auth.auth().currentUser?.uid
    
    var delegateVC = ProfilePreferenceSportsCell()
    let sportsDone = Notification.Name(rawValue: sportsNotificationKey)
    var sportsName = [String]()
    
    var sampleBox = [String]()
    
    @IBOutlet weak var listOfSports: UITableView!

    var sampleSports = ["Badminton", "Baseball", "Basketball", "Ice Hockey", "Soccer", "Table Tennis", "Tennis", "Volleyball"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateVC.selectionDelegate = self
        ref = Database.database().reference()
        configureDatabase()
        creatObservers()

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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)}
    }
    
    func creatObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProfilePreferenceSportsVC.choiceSports(notification:)), name: sportsDone, object: nil)
    }
    
    
    //Done button
    //TODO -
    @objc func choiceSports(notification: Notification) {
        var mdata = [String:String]()
        for i in 0..<(sampleSports.count) {
            if sportsName.contains("\(sampleSports[i])") {
                mdata = ["\(sampleSports[i])":"true"]
                self.ref.child("Users").child("\(userUID!)").child("PreferenceSports")
                    .updateChildValues(mdata)
            } else {
                mdata = ["\(sampleSports[i])":"false"]
                self.ref.child("Users").child("\(userUID!)").child("PreferenceSports")
                    .updateChildValues(mdata)
            }
        }
    }
    
    func configureDatabase() {
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("Users").child("\(userUID!)").child("PreferenceSports")
            .observe(.childAdded, with: { [weak self] (snapshot) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.Preference.append(snapshot)
                strongSelf.listOfSports.insertRows(at: [IndexPath(row: strongSelf.Preference.count-1, section: 0)], with: .automatic)
        })
    }
}

extension ProfilePreferenceSportsVC:UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Preference.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listOfSports.dequeueReusableCell(withIdentifier: "SportsList") as! ProfilePreferenceSportsCell

        //tableview 나 collectionview일 경우, 델리게이트를 self를 작성해준다.
        cell.selectionDelegate = self
        cell.btnSports.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        let preferenceSnapshot: DataSnapshot! = self.Preference[indexPath.row]

        
        if Preference.count > 0 {
            if preferenceSnapshot.value as! String == "true" {
                cell.btnSports.isSelected = true
                cell.btnSports.setTitle(preferenceSnapshot.key, for: .normal)
            } else if preferenceSnapshot.value as! String == "false" {
                cell.btnSports.setTitle(preferenceSnapshot.key, for: .normal)
            }
        }
        return cell
    }
    
    //셀을 선택했을 때, 셀의 색상을 결정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        listOfSports.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selectionColor = UIView() as UIView
        selectionColor.layer.borderWidth = 1
        selectionColor.layer.borderColor = UIColor.clear.cgColor
        selectionColor.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectionColor
    }
}

extension ProfilePreferenceSportsVC:SelectionSportsDelegate {
    func didTapSelect(_ sender: UIButton) {
//        print("Connect Success")
        let btnPosition = sender.convert(sender.bounds.origin, to: listOfSports)
        let indexPath = listOfSports.indexPathForRow(at: btnPosition)
        let rowIndex = sampleSports[(indexPath?.row)!]

        if sportsName.contains(rowIndex) {
            sportsName = sportsName.filter{$0 != "\(rowIndex)"}
        } else {
            sportsName.append("\(rowIndex)")
        }
    }
}
