//
//  ChannelViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 9/8/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdstirMraidViewDelegate{
    
    
    @IBOutlet weak var table: UITableView!
    var items = NSMutableArray()
    var refresh: UIRefreshControl!
    final let API_KEY = Constants.youtube.API_KEY
    final let CHANNEL_ID:String = Constants.youtube.CHANNEL
    var loading = false
    var nextPageToken:NSString!
    var inter: AdstirInterstitial? = nil
    var click_count = 0;

    var adView: AdstirMraidView? = nil
    deinit {
        // デリゲートを解放します。解放を忘れるとクラッシュする可能性があります。
        self.adView?.delegate = nil
        // 広告ビューを解放します。
        self.adView = nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "内さま"
        self.inter = AdstirInterstitial()
        self.inter!.media = Constants.inter_ad.id
        self.inter!.spot = Constants.inter_ad.spot
        self.inter!.load()

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

        // NavigationControllerのタイトルバー(NavigationBar)の色の変更
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        // NavigationConrtollerの文字カラーの変更
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // NavigationControllerのNavigationItemの色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        items = NSMutableArray()
        let nibName = UINib(nibName: "YoutubeTableViewCell", bundle:nil)
        table.registerNib(nibName, forCellReuseIdentifier: "Cell")
        table.delegate = self
        table.dataSource = self
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: Constants.message.UPDATING)
        self.refresh.addTarget(self, action: "viewWillAppear:", forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refresh)
        
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
        // 読み込み開始(必須)
//        nadView.load()
//        self.view.addSubview(nadView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        items = NSMutableArray()
        request(false)

        self.refresh?.endRefreshing()
    }
    
    func request(next: Bool) {
        var urlString:String
        if(next) {
            urlString = "https://www.googleapis.com/youtube/v3/search?key=\(API_KEY)&part=snippet&channelId=\(self.CHANNEL_ID)&pageToken=\(self.nextPageToken)&maxResults=30"
        } else {
            urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UCd8GWuNu4-b0q6Bu0dHysGg&maxResults=30&key=\(API_KEY)"
        }
        let url:NSURL! = NSURL(string:urlString)
        let urlRequest:NSURLRequest = NSURLRequest(URL:url)
        var data:NSData
        var dic: NSDictionary = NSDictionary()
        
        do {
            data = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: nil)
            dic = try NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        } catch {
            print("ERROR")
        }

        if(dic.objectForKey("nextPageToken") != nil) {
            self.nextPageToken = dic.objectForKey("nextPageToken") as! String
        } else {
            self.nextPageToken = nil
        }
        
        let itemsArray: NSArray = dic.objectForKey("items") as! NSArray
        var content: Dictionary<String, String> = ["" : ""]
        itemsArray.enumerateObjectsUsingBlock({ object, index, stop in
            let snippet: NSDictionary = object.objectForKey("snippet") as! NSDictionary
            let ids: NSDictionary = object.objectForKey("id") as! NSDictionary
            let thumbnails: NSDictionary = snippet.objectForKey("thumbnails") as! NSDictionary
            let resolution: NSDictionary = thumbnails.objectForKey("high") as! NSDictionary
            let imageUrl: NSString = resolution.objectForKey("url") as! String
            
            if(ids["kind"] as! String == "youtube#video") {
                content[Constants.article_data.VIDEO_ID] = ids[Constants.article_data.VIDEO_ID] as? String
                content[Constants.article_data.TITLE] = snippet.objectForKey(Constants.article_data.TITLE) as? String
                content[Constants.article_data.IMAGE_URL] = imageUrl as String
                content[Constants.article_data.PUBLISH_AT] = snippet.objectForKey("publishedAt") as? String
                self.items.addObject(content)
            }
        })
        self.table.reloadData()
        self.loading = false
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(self.table.contentOffset.y >= (self.table.contentSize.height - self.table.bounds.size.height)
            && self.nextPageToken != nil
            && loading == false) {
            loading = true
            SVProgressHUD.showWithStatus(Constants.message.LOADING)
                
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if(self.nextPageToken == nil) {
                    
                } else {
                    self.request(true)                
                    SVProgressHUD.dismiss()
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCellWithIdentifier("Cell") as! YoutubeTableViewCell
        let item = self.items[indexPath.row] as! NSDictionary
        
        return CellPreference.setValueToYoutubeViewCell(cell, item: item)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as! NSDictionary
        let con = KINWebBrowserViewController()
        let youtube_url = "https://www.youtube.com/watch?v=" + (item[Constants.article_data.VIDEO_ID] as! String)
        let URL = NSURL(string: youtube_url)
        con.loadURL(URL)
        if click_count % Constants.inter_ad.click_count == 3 {
            self.inter!.showTypeB(self)
        }
        click_count++;

        self.navigationController?.pushViewController(con, animated: true)
    }
  
    
    
}
