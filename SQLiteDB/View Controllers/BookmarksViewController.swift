//
//  BookmarksViewController.swift
//  SQLiteDB
//
//  Created by Mac on 11/10/21.
//

import UIKit

class BookmarksViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        let nibFile = UINib(nibName: "UsersCell", bundle: Bundle.main)
        tableView.register(nibFile, forCellReuseIdentifier: "UsersCell")
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableView.automaticDimension
    }
}
//
//MARK: UITableViewDataSource
//
extension BookmarksViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath)as? UsersCell{
            cell.idLabel.text = String(user.id)
            cell.nameLabel.text = user.name
            cell.imgView.isHidden = true
            return cell
        }else{
            return UITableViewCell()
        }
    }
}
//
//MARK: UITableViewDelegate
//
extension BookmarksViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let thirdViewControllerObj = storyboard?.instantiateViewController(withIdentifier: "ThirdViewController")as? ThirdViewController{
            thirdViewControllerObj.user = user
            thirdViewControllerObj.isFromBookmark = true
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
extension BookmarksViewController: ThirdViewControllerProtocol{
    func bookmarkedRow(row: Int?) {
        guard let element = row else {
            return
        }
        users.remove(at: element)
        tableView.reloadData()
    }
}
