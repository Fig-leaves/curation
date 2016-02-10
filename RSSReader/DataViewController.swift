//
//  TwitterViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/9/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate, AdstirMraidViewDelegate {
    
    var keys: NSArray = ["星7",
        "星6",
        "星5",
        "星4",
        "星3"
    ]
    var url: String = "";
    var title_str: String = ""
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
        
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // NavigationControllerのタイトルバー(NavigationBar)の色の変更
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        // NavigationConrtollerの文字カラーの変更
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // NavigationControllerのNavigationItemの色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let nibName = UINib(nibName: "OtherTableViewCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "キャラクター"
        TrackingManager.sendScreenTracking("キャラクター")
        
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
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func numberOfSectionsInTableView(table: UITableView) -> Int {
        return 1
    }
    
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keys.count
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        var key = self.keys[indexPath.row] as! String
        if(key == "星7") {
            title_str = "星7"
            url = "https://www.kimonolabs.com/api/aq2c637o?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu";
            performSegueWithIdentifier("chara", sender: nil)
        } else if (key == "星6") {
            title_str = "星6"
            url = "https://www.kimonolabs.com/api/2k0oimh2?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu";
            performSegueWithIdentifier("chara", sender: nil)
        } else if(key == "星5") {
            title_str = "星5"
           url = "https://www.kimonolabs.com/api/54af2iz6?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu";
            performSegueWithIdentifier("chara", sender: nil)
        } else if(key == "星4") {
            title_str = "星4"
            url = "https://www.kimonolabs.com/api/4kf9i8ce?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu";
            performSegueWithIdentifier("chara", sender: nil)
        } else if(key == "星3") {
            title_str = "星3"
            url = "https://www.kimonolabs.com/api/c7uw06fs?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu";
            performSegueWithIdentifier("chara", sender: nil)
        }
        TrackingManager.sendEventTracking("キャラクター", action:"Push", label:"閲覧", value:NSNumber(), screen:"キャラクター")
    }
    
    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! OtherTableViewCell
        cell.titleLabel.text = keys[indexPath.row] as! NSString as String
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var withImageViewControlelr = segue.destinationViewController as! WithImageViewController
        withImageViewControlelr.kimono_url = self.url
        withImageViewControlelr.title_str = self.title_str
    }
}
