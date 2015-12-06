//
//  TwitterViewController.swift
//  Curation
//
//  Created by 伊藤総一郎 on 11/5/15.
//  Copyright © 2015 susieyy. All rights reserved.
//

import UIKit
import TwitterKit

class TwitterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdstirMraidViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var items:NSMutableArray!
    
    var adView: AdstirMraidView? = nil
    deinit {
        
        // デリゲートを解放します。解放を忘れるとクラッシュする可能性があります。
        self.adView?.delegate = nil
        // 広告ビューを解放します。
        self.adView = nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Avicii"
        
        let nibName = UINib(nibName: "TweetTableViewCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delaysContentTouches = false
        // NavigationControllerのタイトルバー(NavigationBar)の色の変更
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        // NavigationConrtollerの文字カラーの変更
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // NavigationControllerのNavigationItemの色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        
        // 広告表示位置: タブバーの下でセンタリング、広告サイズ: 320,50 の場合
        let originY = self.view.frame.height
        let originX = (self.view.frame.size.width - kAdstirAdSize320x50.size.width) / 2
        let adView = AdstirMraidView(adSize: kAdstirAdSize320x100, origin: CGPointMake(originX, originY - 100), media: Constants.ad.id, spot:Constants.ad.spot)
        
        // リフレッシュ秒数を設定します。
        adView.intervalTime = 5
        // デリゲートを設定します。
        adView.delegate = self
        
        if(Constants.ad.ENABLE_VIEW) {
            // 広告ビューを親ビューに追加します。
            self.view.addSubview(adView)
            self.adView = adView
        }
        

        
        
        items = NSMutableArray()
        let params : Dictionary<String, String> = ["screen_name" : "@Avicii", "count" : "40"]
        Request.callAPI("/user_timeline.json", parameters: params, completion: {
            response, data, err in
            let json = JSON(data: data!)
            var when : NSDate!
            var item : Dictionary<String, AnyObject> = ["" : ""]
            for (index, subJson):(String, JSON) in json {
                var d = subJson
                for value in d {
                    if value.0 == "text" {
                        item["text"] = value.1.stringValue
                    }
                    if value.0 == "id_str" {
                        item["id_str"] = value.1.stringValue
                    }
                    if value.0 == "created_at" {
                        item["created_at"] = value.1.stringValue
                        when = Snippet.normalizeDateFormat5(value.1.stringValue)
                    }
                    
                    if value.0 == "user" {
                        for v in value.1 {
                            if v.0 == "name" {
                                item["name"] = v.1.stringValue
                            }
                            if v.0 == "screen_name" {
                                item["screen_name"] = v.1.stringValue
                            }
                            if v.0 == "profile_image_url" {
                                item["profile_image_url"] = v.1.stringValue
                            }
                        }
                    }
                }
                item["whenAt"] = Snippet.convertDateformatToWhenAt(when)
                
                print(item)
                self.items.addObject(item)
                self.tableView.reloadData()
            }
        })
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.adView?.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! TweetTableViewCell
        let item = self.items[indexPath.row] as! NSDictionary
        
        return CellPreference.setValueToTweetCell(cell, item: item)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as! NSDictionary
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //        if click_count % Constants.inter_ad.click_count == 0 {
        //            self.inter!.showTypeC(self)
        //        }
        //        click_count++;
        let con = KINWebBrowserViewController()
        var URL: NSURL!
        
        var tw_url = String(UTF8String: "https://twitter.com/Avicii/status/")! + (item["id_str"] as! String)
        URL = NSURL(string: tw_url)
        con.loadURL(URL)
        self.navigationController?.pushViewController(con, animated: true)
    }
}