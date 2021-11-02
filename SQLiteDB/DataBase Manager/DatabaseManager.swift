//
//  DatabaseManager.swift
//  SQLiteDB
//
//  Created by Mac on 10/10/21.
//

import Foundation
import SQLite3

class DBHelper{
    var db: OpaquePointer?
    
    init() {
       db = createAndOpen()
    }
    
    private func createAndOpen() ->OpaquePointer? {
        let dataBaseName = "Users.sqlite"
        var db : OpaquePointer?
        
        do {
            let documentDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dataBaseName)
            if sqlite3_open(documentDir.path, &db) == SQLITE_OK{
                print("Database created and opened successfully..")
                print("Database path \(documentDir.path)")
                return db
            }else{
                print("Database already present.Opened successfully ")
                return db
            }
        } catch {
            print("Unable to get document Directory \(error.localizedDescription)")
        }
        return nil
    }//createAndOpen func end
    
    //
    //MARK: createUserTable
    //
    func createUserTable(){
        var createTableStatement: OpaquePointer?
        let createTableQuery = "CREATE TABLE IF NOT EXISTS user(id INTGER PRIMARY KEY,name TEXT,username TEXT, email TEXT,address TEXT,phone TEXT,website TEXT,company TEXT)"
        
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTableStatement) == SQLITE_DONE{
                print("User table successfully created..")
            }else{
                print("Unable to create User Table!!!")
            }
        }else{
            print("Unable to prepare create table statement!!")
        }
    }//createUserTable function end
    
    typealias successfullyInsert = (_ msg: String, _ title: String) -> Void
    typealias failureInsert = (_ msg: String, _ title: String) -> Void
    
    //
    //MARK: insertValuesInUser
    //
    func insertValuesInUser(user:User, successclosure: successfullyInsert, failureClosure: failureInsert){
        var insertStatement: OpaquePointer?
        let insertQuery = "INSERT INTO user(id,name,username,email,address,phone,website,company) VALUES(?,?,?,?,?,?,?,?)"
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK{
            let idInt32 = Int32(user.id)
            sqlite3_bind_int(insertStatement, 1, idInt32)
            
            let nameNS = user.name as NSString
            let nameText = nameNS.utf8String
            sqlite3_bind_text(insertStatement, 2, nameText, -1, nil)
            
            let userNameNS = user.userName as NSString
            let userNameText = userNameNS.utf8String
            //let UserNameText = (userName as NSString).utf8String
            sqlite3_bind_text(insertStatement, 3, userNameText, -1, nil)
            
            let emailText = (user.email as NSString).utf8String
            sqlite3_bind_text(insertStatement, 4, emailText, -1, nil)
            
            let addressText = (user.address as NSString).utf8String
            sqlite3_bind_text(insertStatement, 5, addressText, -1, nil)
            
            let phoneText = (user.phone as NSString).utf8String
            sqlite3_bind_text(insertStatement, 6, phoneText, -1, nil)
            
            let websiteText = (user.website as NSString).utf8String
            sqlite3_bind_text(insertStatement, 7, websiteText, -1, nil)
            
            let companyText = (user.company as NSString).utf8String
            sqlite3_bind_text(insertStatement, 8, companyText, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE{
                successclosure("User added to Bookmarks", "Successfull")
            }else{
                failureClosure("Already added in Bookmarks", "Failed!!!")
            }
        }else{
            print("Unable to prepare insert Query!!!")
        }
        sqlite3_finalize(insertStatement)
    }//insertValuesInUser func end
    
    typealias successDelete = (_ msg: String, _ title: String) -> Void
    typealias failureDelete = (_ msg: String, _ title: String) -> Void
    
    //
    //MARK: deleteUser
    //
    func deleteUser(id:Int, successClosure: successDelete, failureClosure: failureDelete){
        var deleteStatement: OpaquePointer?
        let deleteQuery = "DELETE FROM user WHERE id = ?"
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK{
            let idInt32 = Int32(id)
            sqlite3_bind_int(deleteStatement, 1, idInt32)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                successClosure("User Deleted successfully", "Successfull")
            }else{
                failureClosure("Unable to delete user", "Failed!!!")
            }
        }else{
            print("unable to prepare delete query!!!")
        }
    }//deleteUser func end
    
    //
    //MARK: emptyDataBase
    //
    typealias emptyDataBase = (_ msg: String, _ title: String) -> Void
    func displayUsers(failureClosure: emptyDataBase) -> [User]? {
        var selectStatement: OpaquePointer?
        let selectQuery = "SELECT * FROM user"
        var users = [User]()
        
        if sqlite3_prepare_v2(db,selectQuery, -1, &selectStatement, nil) == SQLITE_OK{
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                
                let id = Int(sqlite3_column_int(selectStatement, 0))
                guard let name_CStr = sqlite3_column_text(selectStatement, 1) else{
                    print("Error while getting name from db!!!")
                    continue
                }
                let name = String(cString: name_CStr)
                
                guard let username_CStr = sqlite3_column_text(selectStatement, 2) else {
                    print("Error while getting username from db!!!")
                    continue
                }
                let userName = String(cString: username_CStr)
                
                guard let email_CStr = sqlite3_column_text(selectStatement, 3) else {
                    print("Error while getting email from db!!!")
                    continue
                }
                let email = String(cString: email_CStr)
                
                guard let address_CStr = sqlite3_column_text(selectStatement, 4) else {
                    print("Error while getting address from db!!!")
                    continue
                }
                let address = String(cString: address_CStr)
                
                guard let phone_CStr = sqlite3_column_text(selectStatement, 5) else {
                    print("Error while getting phone from db!!!")
                    continue
                }
                let phone = String(cString: phone_CStr)
                
                guard let website_CStr = sqlite3_column_text(selectStatement, 6) else {
                    print("Error while getting website from db!!!")
                    continue
                }
                let website = String(cString: website_CStr)
                
                guard let company_CStr = sqlite3_column_text(selectStatement, 7) else {
                    print("Error while getting copmany name from db!!!")
                    continue
                }
                let company = String(cString: company_CStr)
                                
                let user = User(id: id, name: name, userName: userName, email: email, address: address, phone: phone, website: website, company: company)
                users.append(user)
            }
            sqlite3_finalize(selectStatement)
            return users
        }else{
            failureClosure("Bookmark users first and then try!!!", "Empty BookMark")
        }
        sqlite3_finalize(selectStatement)
        return nil
    }//displayUsers func end
}//class end
