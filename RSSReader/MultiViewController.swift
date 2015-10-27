//
//  MultiViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 9/15/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class MultiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var items = NSMutableArray()
    var refresh: UIRefreshControl!
    
    
    //youtube
    final let API_KEY = Constants.youtube.API_KEY
    final let WORD:String = Constants.youtube.WORD
    var loading = false
    var nextPageToken:NSString!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        items = NSMutableArray()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if self.title == "youtube" {
            let nibName = UINib(nibName: "YoutubeTableViewCell", bundle:nil)
            tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
            
        } else {
            let nibName = UINib(nibName: "BlogTableViewCell", bundle:nil)
            tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        }
        
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: Constants.message.UPDATING)
        self.refresh.addTarget(self, action: "viewWillAppear:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        if self.title == "youtube" {
            request(false)
            
        } else {
            if(appDelegate.blogView == false ) {
                items = NSMutableArray()
                SVProgressHUD.show()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.request(false)
                    SVProgressHUD.dismiss()

                })
                appDelegate.newsView = true
                appDelegate.blogItem = items
            } else {
                items = appDelegate.newsItem
                self.tableView.reloadData()
            }
        }
        
    }
    
    func request(next:Bool) {

        if self.title == "youtube" {
            Request.fetchFromYoutube(next, word: WORD, nextPageToken: self.nextPageToken as String, items: self.items, callback: {
                (data, token) in
                self.items = data
                self.nextPageToken = token
            })
            self.tableView.reloadData()
            self.loading = false
        } else {
            Request.fetchFromBlog(Constants.blog.OFFICIAL_URL) {
                (data) in
                self.items = data
                Snippet.dispatch_async_main({
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row] as! NSDictionary
        if self.title == "youtube" {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! YoutubeTableViewCell
            
            return CellPreference.setValueToYoutubeViewCell(cell, item: item)
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! BlogTableViewCell
            return CellPreference.setValueToBlogViewCell(cell, item: item)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let item = self.items[indexPath.row] as! NSDictionary
        //let con = KINWebBrowserViewController()
        //var youtube_url = "https://www.youtube.com/watch?v=" + (item[Constants.article_data.VIDEO_ID] as! String)
        //let URL = NSURL(string: youtube_url)
        //con.loadURL(URL)
        //
        //self.navigationController?.pushViewController(con, animated: true)
    }
}
