//
//  TwitterViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/9/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate, AdstirMraidViewDelegate {
    
    var keys: NSArray = ["PS4版 自由・雑談掲示板",
                         "PS4版 フレンド・メンバー募集",
                         "XBOX ONE版 自由・雑談掲示板",
                         "XBOX ONE版 フレンド・メンバー募集",
                         "PC版 自由・雑談掲示板",
                         "PC版 フレンド・メンバー募集"
                         ]
    
    var values: NSArray = ["http://swbf.jp/bbs/ps4_talk/",
                           "http://swbf.jp/bbs/ps4_friends/",
                           "http://swbf.jp/bbs/xbox_talk/",
                           "http://swbf.jp/bbs/xbox_friends/",
                           "http://swbf.jp/bbs/pc_talk/",
                           "http://swbf.jp/bbs/pc_friends/"
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
        
        self.title = "掲示板"
        TrackingManager.sendScreenTracking("掲示板")

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

        
        if(indexPath.row < 10) {
            let con = KINWebBrowserViewController()
            let URL = NSURL(string: values[indexPath.row] as! NSString as String)
            con.loadURL(URL)
            
            TrackingManager.sendEventTracking("掲示板", action:"Push", label:"閲覧", value:NSNumber(), screen:"掲示板")

            self.navigationController?.pushViewController(con, animated: true)
        } else {
            // 共有する項目
            let shareText = "Apple - Apple Watch"
            let shareWebsite = NSURL(string: "https://www.apple.com/jp/watch/")!
//            let shareImage = UIImage(named: "shareSample.png")!
            
            let activityItems = [shareText, shareWebsite]
            
            // 初期化処理
            let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            
            // 使用しないアクティビティタイプ
            let excludedActivityTypes = [
                UIActivityTypePostToWeibo,
                UIActivityTypeSaveToCameraRoll,
                UIActivityTypePrint
            ]
            activityVC.excludedActivityTypes = excludedActivityTypes
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }

    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! OtherTableViewCell
        cell.titleLabel.text = keys[indexPath.row] as! NSString as String
        if(indexPath.row == 9 ) {
            let empty = self.tableView.dequeueReusableCellWithIdentifier("EmptyCell") as! EmptyTableViewCell
            return empty
        } else {
            return cell
        }
    }
    // セルの選択を禁止する
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return indexPath
    }

    
    
}
