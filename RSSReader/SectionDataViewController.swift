//
//  SectionDataViewController.swift
//  Curation
//
//  Created by 伊藤総一郎 on 2/3/16.
//  Copyright © 2016 susieyy. All rights reserved.
//

import UIKit

class SectionDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate, AdstirMraidViewDelegate {

    
    var keys: NSArray = [["2015セカンドムシカード"],
        ["2015セカンドおたすけカード"],
        ["2015ファーストムシカード"],
        ["2015ファーストおたすけカード"]
    ]
    var section  = ["pizza", "2", "3", "4"]
    var values: NSArray = ["http://mushiking.boy.jp/cardlist-2/#M-2",
        "http://mushiking.boy.jp/cardlist-2/2",
        "http://mushiking.boy.jp/cardlist/",
        "http://mushiking.boy.jp/cardlist/2",
    ]
    
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
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x397234)
        // NavigationConrtollerの文字カラーの変更
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // NavigationControllerのNavigationItemの色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let nibName = UINib(nibName: "OtherTableViewCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "人物紹介"
        TrackingManager.sendScreenTracking("人物紹介")
        
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
    
    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.section.count
        
    }
    
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keys[section].count
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath!) {
        tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        let con = KINWebBrowserViewController()
        let URL = NSURL(string: values[indexPath.row] as! NSString as String)
        con.loadURL(URL)
        
        TrackingManager.sendEventTracking("カードリスト", action:"Push", label:"閲覧", value:NSNumber(), screen:"カードリスト")
        
        self.navigationController?.pushViewController(con, animated: true)

    }
    
    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! OtherTableViewCell
        cell.titleLabel.text = keys[indexPath.section][indexPath.row] as! NSString as String
        return cell
    }
    // セルの選択を禁止する
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }
    
    
}
