//
//  User.swift
//  ToDoFireBase
//
//  Created by Anton on 17.05.23.
//

import Foundation
import Firebase

struct UserModel {
    
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
