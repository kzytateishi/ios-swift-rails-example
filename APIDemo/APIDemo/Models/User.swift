//
//  User.swift
//  APIDemo
//
//  Created by Kazuya Tateishi on 2015/03/25.
//  Copyright (c) 2015年 kzy52. All rights reserved.
//

import UIKit

struct User {
    var name: String, email: String
}

class UserDataManager: NSObject {
    var users: [User]
    
    // シングルトンにする
    // UserDataManager.sharedInstanceで常に同じインスタンスを取り出すことができる。
    class var sharedInstance : UserDataManager {
        struct Static {
            static let instance : UserDataManager = UserDataManager()
        }
        return Static.instance
    }
    
    override init() {
        self.users = []
    }
    
    // ユーザーの総数を返す。
    var size : Int {
        return self.users.count
    }
    
    // 配列のように[n]で要素を取得できるようにする。
    subscript(index: Int) -> User {
        return self.users[index]
    }
    
    func set(user: User) {
        self.users.append(user)
    }
}