//
//  SecondViewController.swift
//  SQLiteDB
//
//  Created by Mac on 10/10/21.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var usersArray = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "UsersCell", bundle: Bundle.main), forCellReuseIdentifier: "UsersCell")
    }
}
//
//MARK: UITableViewDataSource
//
extension SecondViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = usersArray[indexPath.row]
        
        if let userCell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath)as? UsersCell{
            if user.flag == 1{
                userCell.imgView.isHidden = false
            }else{
                userCell.imgView.isHidden = true
            }
            userCell.idLabel.text = String(user.id)
            userCell.nameLabel.text = user.name
            return userCell
        }else{
            return UITableViewCell()
        }
    }
}
//
//MARK: UITableViewDelegate
//
extension SecondViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersArray[indexPath.row]
        if let thirdViewControllerObj = storyboard?.instantiateViewController(withIdentifier: "ThirdViewController")as? ThirdViewController{
            thirdViewControllerObj.user = user
            thirdViewControllerObj.row = indexPath.row
            thirdViewControllerObj.delegate = self
            navigationController?.pushViewController(thirdViewControllerObj, animated: true)
        }else{
            print("Unable to find ThirdViewController in storyboard..")
        }
    }
}
//
//MARK: ThirdViewControllerProtocol
//
extension SecondViewController:ThirdViewControllerProtocol{
    func bookmarkedRow(row: Int?) {
        if let row = row{
            usersArray[row].flag = 1
            tableView.reloadData()
        }
    }
}
