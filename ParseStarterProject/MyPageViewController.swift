//
//  MyPageViewController.swift
//  ParseStarterProject
//
//  Created by 安井 梨沙子 on 2016/01/28.
//  Copyright © 2016年 Parse. All rights reserved.
//

//
//  ThirdViewController.swift
//  MapDemo
//
//  Created by 安井 梨沙子 on 2016/01/24.
//  Copyright (c) 2016年 安井 梨沙子. All rights reserved.
//

//
//  TableTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by 安井 梨沙子 on 2016/01/27.
//  Copyright © 2016年 Parse. All rights reserved.
//

import UIKit
import Parse

class MyPageViewController: UIViewController {
    
    
    var usernames = [""]
    var userids = [""]
    
    var refresher: UIRefreshControl!
    
    func refresh() {
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let users = objects {
                
                self.usernames.removeAll(keepCapacity: true)
                self.userids.removeAll(keepCapacity: true)
                
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.usernames.append(user.username!)
                        self.userids.append(user.objectId!)
                    }
                }
            }
            
            
            print(self.usernames)
            print(self.userids)
            
            //self.tableView.reloadData()
            
            self.refresher.endRefreshing()
        })
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //引っ張ってリフレッシュ
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "読み込み中")
        
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        //self.tableView.addSubview(refresher)
        
        refresh()   //スタートでリフレッシュ
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
/*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = usernames[indexPath.row]
        
        return cell
    }
 */
    

    
}
