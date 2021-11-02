//
//  UsersModal.swift
//  SQLiteDB
//
//  Created by Mac on 10/10/21.
//

import Foundation
struct User {
    
    var id: Int
    var name: String
    var userName: String
    var email: String
    var address: String
    var phone: String
    var website: String
    var company: String
    var flag: Int
    
    init(id: Int,name: String,userName: String,email: String,address: String,phone: String,website: String,company: String,flag: Int = 0) {
        self.id = id
        self.name = name
        self.userName = userName
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
        self.flag = flag
    }
}
