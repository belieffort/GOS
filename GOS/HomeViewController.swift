//
//  HomeViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 13..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    var ref: DatabaseReference!
    var recruitment: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?
    
    var seletedCollectionViewCell:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureDatabase()
    }
    //셀 클릭했을 때, 이동할 수 있게 해준다.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        seletedCollectionViewCell = indexPath
//        print("==============\(String(describing: seletedCollectionViewCell))=============")
        performSegue(withIdentifier: "MainDetailSegue", sender: self)

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recruitment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recruitCell", for: indexPath) as! RecruitCellCollectionViewCell

        let recruitmentSnapshot: DataSnapshot! = self.recruitment[indexPath.row]
        guard let recruit = recruitmentSnapshot.value as? [String:String] else { return cell }
                
        let sportsBox = recruit["Sports"] ?? "[Sports]"
        switch sportsBox{
        case "농구":
            cell.playImages.image = UIImage(named: "Main_basketball.jpg")
        case "축구":
            cell.playImages.image = UIImage(named: "Main_soccer.jpg")
        case "배구":
            cell.playImages.image = UIImage(named: "Main_volleyball.jpg")
        case "야구":
            cell.playImages.image = UIImage(named: "Main_baseball.jpg")
        case "탁구":
            cell.playImages.image = UIImage(named: "Main_tabletennis.jpg")
        case "테니스":
            cell.playImages.image = UIImage(named: "Main_tennis.jpg")
        case "배드민턴":
            cell.playImages.image = UIImage(named: "Main_badminton.jpg")
        case "아이스 하키":
            cell.playImages.image = UIImage(named: "Main_icehockey.jpg")
        default:
            break
        }
        
        let time = recruit["Time"] ?? "[Time]"
        let location = recruit["Location"] ?? "[Location]"
        let numberOfPeople = recruit["NumberOfPeople"] ?? "[numberOfPeople]"
        
        cell.playSchedule.text = time
        cell.playLocation.text = location
        cell.recruitPerson.text = numberOfPeople
        
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
                if let refHandle = _refHandle {
                    self.ref.child("Recruitment").removeObserver(withHandle: refHandle)}
        }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
                _refHandle = self.ref.child("Recruitment").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
                    guard let strongSelf = self else { return }
                    strongSelf.recruitment.append(snapshot)
                    strongSelf.homeCollectionView.insertItems(at: [IndexPath(row: strongSelf.recruitment.count-1, section: 0)])
                    
                })
    }
    //어떤 데이터를 넘겨줄 것인지
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let recruitmentSnapshot: DataSnapshot! = self.recruitment[seletedCollectionViewCell.item]
        guard let recruit = recruitmentSnapshot.value as? [String:String] else { return }
        
        // TODO - Recruitment의 child name을 찾으면 된다!!
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.userID = recruit["Writer"] ?? "[Writer]"
        detailViewController.titleBox = recruit["Title"] ?? "[Title]"
        detailViewController.time = recruit["Time"] ?? "[Time]"
        detailViewController.location = recruit["Location"] ?? "[Location]"
        detailViewController.people = recruit["NumberOfPeople"] ?? "[NumberOfPeople]"
        detailViewController.position = recruit["Position"] ?? "[Position]"
        detailViewController.notice = recruit["Detail"] ?? "[Detail]"
        detailViewController.passedIndex = seletedCollectionViewCell
        detailViewController.writeNumber = recruit["WriteNumber"] ?? "[WriteNumber]"
        
    }


}
