//
//  TwitterViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/9/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class BlogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdstirMraidViewDelegate {
    var items = NSMutableArray()
    var loading = false
    var refresh: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!

    var adView: AdstirMraidView? = nil
    deinit {
        // デリゲートを解放します。解放を忘れるとクラッシュする可能性があります。
        self.adView?.delegate = nil
        // 広告ビューを解放します。
        self.adView = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 広告表示位置: タブバーの下でセンタリング、広告サイズ: 320,50 の場合
        let originY = self.view.frame.height
        let originX = (self.view.frame.size.width - kAdstirAdSize320x50.size.width) / 2
        let adView = AdstirMraidView(adSize: kAdstirAdSize320x50, origin: CGPointMake(originX, originY - 100), media: Constants.ad.id, spot:Constants.ad.spot)
        
        // リフレッシュ秒数を設定します。
        adView.intervalTime = 5
        // デリゲートを設定します。
        adView.delegate = self
        
        // 広告ビューを親ビューに追加します。
        self.view.addSubview(adView)
        self.adView = adView
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let nibName = UINib(nibName: "BlogTableViewCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        items = NSMutableArray()
        tableView.delegate = self
        tableView.dataSource = self
        self.title = Constants.title.BLOG
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: Constants.message.UPDATING)
        self.refresh.addTarget(self, action: Selector("reload"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reload() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.request()
            self.refresh?.endRefreshing()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
               
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(appDelegate.blogView == false ) {
            items = NSMutableArray()
            SVProgressHUD.show()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.request()
                SVProgressHUD.dismiss()
            })
            appDelegate.blogView = true
        } else {
            items = appDelegate.blogItem
            self.tableView.reloadData()
        }
    }
    func request() {
        Request.fetchFromBlog(Constants.blog.OFFICIAL_URL) {
            (data) in
            self.items = data
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.blogItem = self.items
            Snippet.dispatch_async_main({
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! BlogTableViewCell
        let item = self.items[indexPath.row] as! NSDictionary
        
        return CellPreference.setValueToBlogViewCell(cell, item: item)
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as! NSDictionary
        
        let con = KINWebBrowserViewController()
        let URL = NSURL(string: item[Constants.article_data.HREF] as! NSString as String)
        con.loadURL(URL)
        self.navigationController?.pushViewController(con, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)
            && self.loading == false) {
            SVProgressHUD.showWithStatus(Constants.message.LOADING)
            self.loading = true
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SVProgressHUD.dismiss()
            })
        }
    }

}