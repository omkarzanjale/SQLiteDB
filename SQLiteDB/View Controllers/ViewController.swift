//
//  ViewController.swift
//  SQLiteDB
//
//  Created by Mac on 10/10/21.
//
/*
    Program - Getting data from api and display some contents of it after selecting perticular row it displays all data related to it  on another vc and with an button perform action to add it to database and also diplay bookmark logo for that on cell
    also diplay data from database 
 */

import UIKit

class ViewController: UIViewController {

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home Page"
    }
    
    private func showAlert(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func bookmarksBtnAction(_ sender: UIButton) {
        let dBHelperObj = DBHelper()
        let usersData = dBHelperObj.displayUsers() { mssg,title in
            showAlert(message: mssg, title: title)
        }
        guard let usersFromDb = usersData else{
            print("nil data obtained from db!!!")
            return
        }
        if let bookmarksViewControllerObj = storyboard?.instantiateViewController(withIdentifier: "BookmarksViewController")as? BookmarksViewController{
            bookmarksViewControllerObj.users = usersFromDb
            navigationController?.pushViewController(bookmarksViewControllerObj, animated: true)
        }else{
            print("Unable to indentify BookmarksViewController on storyBoard")
        }
    }
    
    @IBAction func dataBtnAction(_ sender: UIButton) {
        dataFromAPI()
    }
    
    private func navigateToSecondVC() {
        defer {
            users.removeAll()
        }
        if let secondViewControllerObj = storyboard?.instantiateViewController(withIdentifier: "SecondViewController")as? SecondViewController{
            secondViewControllerObj.usersArray = users
            navigationController?.pushViewController(secondViewControllerObj, animated: true)
        }else{
            print("SecondViewController not found in storyBoard")
        }
    }
    //
    //MARK: API CALL
    //
    private func dataFromAPI(){
        let urlString = "https://jsonplaceholder.typicode.com/users"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { [weak self] dataFromserver, response, error in
                guard let data = dataFromserver else{
                    print("Data not present..")
                    return
                }
                self?.ManualFetchingDataFromAPI(data)
                
                DispatchQueue.main.async {
                    self?.navigateToSecondVC()
                }
            }
            dataTask.resume()
        } else{
            print("Invalid Url")
        }
    }
    
    private func ManualFetchingDataFromAPI(_ data: Data){
        guard let usersArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] else {
            return
        }
        
        for user in usersArray {
            let address = user["address"] as? [String: Any]
            guard let company = user["company"] as? [String: String] else {
                return
            }
            let completeAddress = self.parseAddress(address)
            let user = User(id: (user["id"] as? Int) ?? 0, name: (user["name"] as? String) ?? "", userName: (user["username"]as? String) ?? "", email: (user["email"] as? String) ?? "",address: completeAddress ?? "",phone: (user["phone"] as? String) ?? "", website: (user["website"] as? String) ?? "",company: (company["name"] as? String) ?? "")
            self.users.append(user)
        }
    }
    
    private func parseAddress(_ address: [String: Any]?) -> String {
        guard let address = address else {
            return ""
        }
        let street = (address["street"] as? String) ?? ""
        let apt = (address["suite"] as? String) ?? ""
        let city = (address["city"] as? String) ?? ""
        let zip = (address["zipcode"] as? String) ?? ""
        let completeAddress = apt + street + city + zip
        return completeAddress
    }
}
