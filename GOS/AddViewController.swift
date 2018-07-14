//
//  AddViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 15..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var listOfSports: UIPickerView!
    @IBOutlet weak var addVIew_Time: UITextField!
    @IBOutlet weak var addView_Loaction: UITextField!
    @IBOutlet weak var addView_Person: UITextField!
    @IBOutlet weak var addView_Detail: UITextView!
    
    var sports = ["농구","축구","배구","테니스","야구","배드민턴","탁구","아이스 하키"]

    override func viewDidLoad() {
        super.viewDidLoad()
        addView_Detail.layer.borderWidth = 0.5
        addView_Detail.layer.borderColor = UIColor.lightGray.cgColor
        addView_Detail.layer.cornerRadius = 5.0
        
    }
  

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sports.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sports[row]
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
