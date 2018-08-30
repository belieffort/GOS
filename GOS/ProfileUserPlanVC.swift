//
//  ProfileUserPlan.swift
//  GOS
//
//  Created by 한병두 on 2018. 8. 27..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ProfileUserPlanVC: UIViewController {
    
    @IBOutlet weak var planTableView: UITableView!
    var ref: DatabaseReference!
    var plans: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    var passUID:String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getUserPlan()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        if let refHandle = _refHandle {
            self.ref.child("Users").removeObserver(withHandle: refHandle)}
    }

    func getUserPlan() {
           _refHandle = self.ref.child("Users").child("\(passUID!)").child("Join")
                .observe(.childAdded, with: { [weak self] (snapshot) in
                    guard let strongSelf = self else { return }
                    strongSelf.plans.append(snapshot)
                    strongSelf.planTableView.insertRows(at: [IndexPath(row: strongSelf.plans.count-1, section: 0)], with: .automatic)
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

extension ProfileUserPlanVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = planTableView.dequeueReusableCell(withIdentifier: "PlanCell", for: indexPath) as! ProfileUserPlanTableViewCell

        let userSnapshot: DataSnapshot! = self.plans[indexPath.row]
        guard let plan = userSnapshot.value as? [String:AnyObject] else { return cell }

        let title = plan["Title"] as? String
        let location = plan["Location"] as? String
//        let time = plan["Time"] as? String

        cell.userPlanTitle.text = title
        cell.userPlanLocation.text = location

        return cell
    }
}
