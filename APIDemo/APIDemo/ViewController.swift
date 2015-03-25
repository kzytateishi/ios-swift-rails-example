//
//  ViewController.swift
//  APIDemo
//
//  Created by Kazuya Tateishi on 2015/03/25.
//  Copyright (c) 2015年 kzy52. All rights reserved.
//

import UIKit
import Alamofire

// UITableViewを使用する際はUITableViewDataSourceプロトコルとUITableViewDelegateプロトコルを実装する必要がある
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellId = "MyCell"
    
    // 今回はテーブル表示にしたいので UITableView を使う
    var tableView : UITableView?
    
    var users = UserDataManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 横幅、高さ、ステータスバーの高さを取得する
        let width: CGFloat! = self.view.bounds.width
        let height: CGFloat! = self.view.bounds.height
        let statusBarHeight: CGFloat! = UIApplication.sharedApplication().statusBarFrame.height
        
        self.tableView = UITableView(frame: CGRectMake(0, statusBarHeight, width, height - statusBarHeight))
        
        // デリゲートを指定する
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        // UITableViewにセルとして使うクラスを登録する
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        // Viewに追加する。
        self.view.addSubview(self.tableView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.request()
    }
    
    // セルの総数を返す(表示するテーブルの行数)
    // UITableViewDataSource を使う場合は 必須
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.size
    }
    
    // 表示するセルを生成して返す
    // UITableViewDataSource を使う場合は 必須
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // UITableViewCellはテーブルの一つ一つのセルを管理するクラス。
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as UITableViewCell
        
        // Cellに値を設定する.
        let user: User = self.users[indexPath.row] as User
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    // Web API をコールする
    func request() {
        Alamofire.request(Router.GetUsers()).responseJSON { (request, response, json, error) -> Void in
            if let json = json as? Array<Dictionary<String,AnyObject>> {
                for j in json {
                    var user: User = User(
                        name: j["name"] as NSString,
                        email: j["email"] as NSString
                    )
                    self.users.set(user)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView!.reloadData()
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}