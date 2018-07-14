//
//  ViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 12..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var playImages = [UIImage(named: "basketball.jpg"), UIImage(named: "tennis.jpg"), UIImage(named: "baseball.jpg"), UIImage(named: "badminton.jpg")]
    var playLocation = ["한강시민공원 농구장", "양재 테니스장", "난지 야구장", "성미산 경기장"]
    var playSchedule = ["2018년 8월 1일 오후 7시","2018년 7월 30일 오후 8시","2018년 8월 5일 오전 10시","2018년 8월 10일 오후 6시 "]
    var recruitPerson = ["2명","1명","5명","3명"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playLocation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recruitCell", for: indexPath) as! RecruitCellCollectionViewCell
        
        cell.playImages.image = playImages[indexPath.row]
        cell.playLocation.text = playLocation[indexPath.row]
        cell.playSchedule.text = playSchedule[indexPath.row]
        cell.recruitPerson.text = recruitPerson[indexPath.row]
        
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

}

