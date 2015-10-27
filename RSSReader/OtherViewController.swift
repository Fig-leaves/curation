//
//  TwitterViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/9/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate {
    
    var keys: NSArray = ["バナナムーン",
                         "   radiko",
                         "   ラジオのHP",
                         "バナナTV",
                         "Twitter",
                         "Facebook"
                         ]
    var values: NSArray = ["banana moon",
                           "http://radiko.jp/",
                           "http://www.tbsradio.jp/banana/index.html",
                           "http://www.tv-asahi.co.jp/douga/bananatv_15",
                           "https://twitter.com/banana__tv",
                           "https://www.facebook.com/BANANA.TV.87",
                        ]

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        // NavigationControllerのタイトルバー(NavigationBar)の色の変更
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        // NavigationConrtollerの文字カラーの変更
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // NavigationControllerのNavigationItemの色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        let nibName = UINib(nibName: "OtherTableViewCell", bundle:nil)
        table.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        let emptyCell = UINib(nibName: "EmptyTableViewCell", bundle:nil)
        table.registerNib(emptyCell, forCellReuseIdentifier: "EmptyCell")
        
        table.delegate = self
        table.dataSource = self
        
        self.title = Constants.title.OTHER
        
//        // NADViewクラスを生成
//        nadView = NADView(frame: CGRect(x: Constants.frame.X,
//            y: Constants.frame.Y,
//            width: Constants.frame.WIDTH,
//            height: Constants.frame.HEIGHT))
//        // 広告枠のapikey/spotidを設定(必須)
//        nadView.setNendID(Constants.nend_id.API_ID, spotID: Constants.nend_id.SPOT_ID)
//        // nendSDKログ出力の設定(任意)
//        nadView.isOutputLog = true
//        // delegateを受けるオブジェクトを指定(必須)
//        nadView.delegate = self
//        // 読み込み開始(必須)
//        nadView.load()
//        // 通知有無にかかわらずViewに乗せる場合
//        self.view.addSubview(nadView)

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
        if(indexPath.row < 10) {
            let con = KINWebBrowserViewController()
            let URL = NSURL(string: values[indexPath.row] as! NSString as String)
            con.loadURL(URL)
            
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
            
            // UIActivityViewControllerを表示
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }

    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("Cell") as! OtherTableViewCell
        cell.titleLabel.text = keys[indexPath.row] as! NSString as String
        if(indexPath.row == 9 ) {
            let empty = self.table.dequeueReusableCellWithIdentifier("EmptyCell") as! EmptyTableViewCell
            return empty
        } else {
            return cell
        }
    }
    // セルの選択を禁止する
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if(indexPath.row == 4) {
            return nil
        }
        return indexPath
    }

    
    
}
