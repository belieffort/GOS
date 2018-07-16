//
//  ProfileViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 15..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileID: UILabel!
    
    
    var time = [String]()
    var location = [String]()
    var sportsImage = [UIImage(named: "badminton-1"), UIImage(named: "football-1"), UIImage(named: "basketball-1"), UIImage(named: "hockey-1"), UIImage(named: "tennis-1")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        time = ["2018년 7월 20일 금요일 오후 8시", "2018년 7월 22일 일요일 오후 2시", "2018년 7월 25일 수요일 오후 8시", "2018년 7월 28일 토요일 오전 10시", "2018년 7월 31일 화요일 오후 8시"]
        location = ["마포구 배드민턴 경기장", "서대문구 풋볼 경기장", "여의도 농구장", "광운대 아이스하키 경기장", "중랑구 야외 테니스 경기장"]
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
            
            print("로그아웃 되었습니다.")
        } catch {
            print("Logout Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return time.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        
        cell.scheduleTime.text = time[indexPath.row]
        cell.scheduleLocation.text = location[indexPath.row]
        cell.sportsImage.image = sportsImage[indexPath.row]
        return cell

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
