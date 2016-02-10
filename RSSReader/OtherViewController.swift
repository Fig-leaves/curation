//
//  TwitterViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/9/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate, AdstirMraidViewDelegate {
    
    var keys: NSArray = ["必殺技一覧",
                         "スキル一覧",
                         "切替技一覧"
                         ]
    var values: NSArray = ["http://grimmnotes.gamerch.com/%E5%BF%85%E6%AE%BA%E6%8A%80%E4%B8%80%E8%A6%A7",
                           "http://grimmnotes.gamerch.com/%E3%82%B9%E3%82%AD%E3%83%AB%E4%B8%80%E8%A6%A7",
                           "http://grimmnotes.gamerch.com/%E5%88%87%E6%9B%BF%E6%8A%80%E4%B8%80%E8%A6%A7"
                        ]
    @IBOutlet weak var tableView: UITableView!
    
    var adView: AdstirMraidView? = nil
    deinit {
        self.adView?.delegate = nil
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
        
        let emptyCell = UINib(nibName: "EmptyTableViewCell", bundle:nil)
        tableView.registerNib(emptyCell, forCellReuseIdentifier: "EmptyCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "データ"
        TrackingManager.sendScreenTracking("データ")

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
        let con = KINWebBrowserViewController()
        let URL = NSURL(string: values[indexPath.row] as! NSString as String)
        con.loadURL(URL)
        
        TrackingManager.sendEventTracking("武器", action:"Push", label:"閲覧", value:NSNumber(), screen:"武器")

        self.navigationController?.pushViewController(con, animated: true)

    }

    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! OtherTableViewCell
        cell.titleLabel.text = keys[indexPath.row] as! NSString as String
        return cell
    }
    // セルの選択を禁止する
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }

    
    
}
