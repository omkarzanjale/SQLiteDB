//
//  ThirdViewController.swift
//  SQLiteDB
//
//  Created by Mac on 10/10/21.
//

import UIKit

protocol ThirdViewControllerProtocol:AnyObject {
    func bookmarkedRow(row:Int?)
}

class ThirdViewController: UIViewController {
    //
    //  MARK: Outlets
    //
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    weak var delegate: ThirdViewControllerProtocol?
    
    var user: User?
    var row: Int?
    var isFromBookmark:Bool?
       
    override func viewDidLoad() {
        super.viewDidLoad()
        showBarButtons()
        ShowData()
    }
    
    private func ShowData(){
        if let user = user{
            idLabel.text = String(user.id)
            nameLabel.text = user.name
            userNameLabel.text = user.userName
            emailLabel.text = user.email
            addressLabel.text = user.address
            phoneLabel.text = user.phone
            websiteLabel.text = user.website
            companyLabel.text = user.company
        }else{
            print("failed to pass data")
        }
    }
    
    private func showBarButtons(){
        if isFromBookmark == true {
            let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteUserBtnAction))
            navigationItem.rightBarButtonItem = deleteBarButton
        }else{
            let bookmarkBarButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarkAction))
            navigationItem.rightBarButtonItem = bookmarkBarButton
        }
    }
    //
    //MARK: bookmarkAction
    //
    @objc func bookmarkAction() {
        guard let user = user else {
            return
        }
        let databaseHelper = DBHelper()
        databaseHelper.createUserTable()
        databaseHelper.insertValuesInUser(user: user) { (mssg, title) in
            showAlert(message: mssg, title: title)
        } failureClosure: { (mssg, title) in
            showAlert(message: mssg, title: title)
        }
        delegate?.bookmarkedRow(row: row)
    }
    
    private func showAlert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //
    //MARK: deleteUserBtnAction
    //
    @objc func deleteUserBtnAction(){
        guard let user = user else {
            return
        }
        let databaseHelper = DBHelper()
        databaseHelper.deleteUser(id: user.id) { (mssg, title) in
            showAlert(message: mssg, title: title)
        } failureClosure: { (mssg, title) in
            showAlert(message: mssg, title: title)
        }
        delegate?.bookmarkedRow(row: row)
    }
}
