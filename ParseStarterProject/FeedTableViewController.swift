//
//  FeedTableViewController.swift
//  ParseStarterProject
//
//  Created by 安井 梨沙子 on 2016/01/28.
//  Copyright © 2016年 Parse. All rights reserved.
//

import UIKit
import Bolts
import Parse

class FeedTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Feedtable: UITableView!
    
    var titles = [""]
    var usernames = [""]
    var userids = [""]
    var imageFiles = [PFFile]()
    var users = [String: String]()
    var details = [""]
    
    var selectedObjectId:String = ""
    
    override func viewDidLoad() {
        

        
        super.viewDidLoad()
        
        Feedtable.delegate = self
        Feedtable.dataSource = self
        
        Feedtable.estimatedRowHeight = 140
        Feedtable.rowHeight = UITableViewAutomaticDimension
        
        self.title = "みんなのあしあと"
        
        var query = PFUser.query()
        
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            
            if let users = objects {
                
                self.titles.removeAll(keepCapacity: true)
                self.users.removeAll(keepCapacity: true)
                self.imageFiles.removeAll(keepCapacity: true)
                self.usernames.removeAll(keepCapacity: true)
                self.details.removeAll(keepCapacity: true)
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                }
            }
            
            
            let getUsersQuery = PFQuery(className: "User")
            
            //getUsersQuery.whereKey("user", equalTo: currentUser)
            
            getUsersQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                
                if let users = objects {
                    
                  //  for user in objects {
                        
                        //var followedUser = object["following"] as! String
                        
                        let query = PFQuery(className: "Post")
                        
                        //query.whereKey("userId", equalTo: )
                        
                        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                            
                            if let objects = objects {
                                
                                for object in objects {
                                    
                                    
                                    
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    
                                    self.usernames.append(self.users[object["userId"] as! String]!)
                                    
                                    self.titles.append(object["title"] as! String)
                                    
                                    self.details.append(object["detail"] as! String)
                                    
                                    self.Feedtable.reloadData()
                                    
                                }
                                
                            }
                            
                            
                        })
                   // }
                    
                }
                
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return imageFiles.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) -> Void in
            
            if let downloadedImage = UIImage(data: data!) {
                
                myCell.postedImage.image = downloadedImage
                
            }
            
        }
        
        
        
        myCell.userName.text = usernames[indexPath.row]
        
        myCell.title.text = titles[indexPath.row]
        
        myCell.detail.text = details[indexPath.row]
        
        
        print(imageFiles.count)
        print(titles.count)
        
        return myCell
        
    }
    
    

    
    
    
    
    
    
    
    
//    
//    
//    
//    var refresher: UIRefreshControl!
//    
//    func refresh() {
//        
//        let query = PFUser.query()
//        
//        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//            
//            if let users = objects {
//                
//                self.usernames.removeAll(keepCapacity: true)
//                self.userids.removeAll(keepCapacity: true)
//                self.titles.removeAll(keepCapacity: true)
//                self.users.removeAll(keepCapacity: true)
//                self.imageFiles.removeAll(keepCapacity: true)
//
//                
//                for object in users {
//                    
//                    if let user = object as? PFUser {
//                        
//                        //self.usernames.append(user.username!)
//                        //self.userids.append(user.objectId!)
//                        
//                        
//                        
//                        
//                        
//                    }
//                }
//                
//            }
//            
//            print(self.usernames)
//            print(self.userids)
//            
//            self.tableView.reloadData()
//            
//            self.refresher.endRefreshing()
//        })
//        
//        
//        let query2 = PFQuery(className: "Post")
//        
//        
//        
//        
//        
//        
//        
//        
//    }
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //引っ張ってリフレッシュ
//        
//        refresher = UIRefreshControl()
//        
//        refresher.attributedTitle = NSAttributedString(string: "読み込み中")
//        
//        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        
//        self.tableView.addSubview(refresher)
//        
//        refresh()   //スタートでリフレッシュ
//        
//        
//        
//        
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//        
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Table view data source
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return usernames.count
//    }
//    
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! cell
//        
//        myCell.userName.text = usernames[indexPath.row]
//        
//        return myCell
//    }
//
//    
//    
//    
//    
//    
//    
//    
    
    


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
