//
//  AddViewController.swift
//  GOS
//
//  Created by 한병두 on 2018. 7. 15..
//  Copyright © 2018년 Byungdoo Han. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import UITextView_Placeholder

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var _refHandle: DatabaseHandle?

    //UIPickerView를 사진으로 보여주고, 가로로 넘겨가면서 선택하게 하기!
    @IBOutlet weak var listOfSports: UIPickerView!

    @IBOutlet weak var addView_Title: UITextField!
    @IBOutlet weak var addView_Time: UITextField!
    @IBOutlet weak var addView_Loaction: UITextField!
    @IBOutlet weak var addView_Person: UITextField!
    @IBOutlet weak var addView_position: UITextField!
    @IBOutlet weak var addView_Detail: UITextView!
    
    var userUID = Auth.auth().currentUser?.uid
    var userEmail = Auth.auth().currentUser?.email
    var selectedSports:String!
    var sports = ["Basketball","Soccer","Volleyball","Tennis","Baseball","Badminton","Table Tennis","Ice Hockey"]
    var countBox:String!
    var convertCountBox:Int!
//    var writeTime:String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Recruitment").observeSingleEvent(of: .value, with: {(snap) in
            self.countBox = "\(snap.childrenCount)"
        })
        
        //TODO : 게시글 정렬을 최신 글이 가장 상단에 위치하게 해야한다.
        selectedSports = sports[0]
        addView_Detail.layer.borderWidth = 0.5
        addView_Detail.layer.borderColor = UIColor.lightGray.cgColor
        addView_Detail.layer.cornerRadius = 5.0
        addView_Detail.placeholder = "추가적인 전달사항"
        addView_Detail.placeholderColor = UIColor.lightGray
        self.hideKeyboardTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddViewController.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        configureDatabase()
    }
    
    
    
    @IBAction func btnDone(_ sender: Any) {
        //TODO - 버튼 눌렀을 때, 홈으로 이동하게 해야한다
        //TODO - Firebase에 업로드 하자마자, 업로드한 내용을 바로 기기에 적용시키는 방법이 없는지?? 왜냐하면 여러 명이 글을 동시에 쓰면 글이 서로 덮어질 것 같다.
//        let now = Date()
//        let date = DateFormatter()
//        date.locale = Locale(identifier: "ko_kr")
//        date.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        writeTime = date.string(from: now)
        
        var mdata = [String:String]()

        mdata["Title"] =  addView_Title.text
        mdata["Sports"] =  selectedSports
        mdata["Time"] = addView_Time.text
        mdata["Location"] = addView_Loaction.text
        mdata["NumberOfPeople"] = addView_Person.text
        mdata["Position"] = addView_position.text
        mdata["Detail"] = addView_Detail.text
        mdata["WriterUID"] = userUID
        mdata["WriterEmail"] = userEmail

        // Push data to Firebase Database
        self.ref.child("Recruitment").childByAutoId().setValue(mdata)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSports = sports[row]
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
    
    deinit {
//        if let refHandle = _refHandle {
//            self.ref.child("messages").removeObserver(withHandle: _refHandle)
//        }
    }
    
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
//        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
//            guard let strongSelf = self else { return }
//            strongSelf.messages.append(snapshot)
//            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
//        })
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

}

extension AddViewController {
    func hideKeyboardTappedAround() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}
