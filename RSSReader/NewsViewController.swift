//
//  TwitterViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/9/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdstirMraidViewDelegate  {

    var items = NSMutableArray()
    var articles = NSMutableArray()
    var refresh: UIRefreshControl!
    var loading = false
    @IBOutlet weak var table: UITableView!
    var inter: AdstirInterstitial? = nil
    var click_count = 1
    
    var adView: AdstirMraidView? = nil
    deinit {
        // デリゲートを解放します。解放を忘れるとクラッシュする可能性があります。
        self.adView?.delegate = nil
        // 広告ビューを解放します。
        self.adView = nil
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        TrackingManager.sendScreenTracking("ニュース")
        
        self.inter = AdstirInterstitial()
        self.inter!.media = Constants.inter_ad.id
        self.inter!.spot = Constants.inter_ad.spot
        self.inter?.delegate = nil
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
        
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x397234)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let nibName = UINib(nibName: "NewsTableViewCell", bundle:nil)
        table.registerNib(nibName, forCellReuseIdentifier: "Cell")
        
        items = NSMutableArray()
        articles = NSMutableArray()
        table.delegate = self
        table.dataSource = self
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: Constants.message.UPDATING)
        
        self.title = Constants.title.NEWS
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(appDelegate.newsView == false ) {
            SVProgressHUD.showWithStatus(Constants.message.LOADING)
            items = NSMutableArray()
            articles = NSMutableArray()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.get_article()
                self.table.reloadData()
                self.refresh?.endRefreshing()
                SVProgressHUD.dismiss()
            })
            appDelegate.newsView = true
            appDelegate.newsItem = items
        } else {
            items = appDelegate.newsItem
            self.table.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func reload() {
        items = NSMutableArray()
        articles = NSMutableArray()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.get_article()
            self.table.reloadData()
            self.refresh?.endRefreshing()
        })
    }
    
    func get_article() {

        self.request(Constants.article_url.NEWS_SITE1)
        if(Constants.article_url.NEWS_SITE2 != "") {
            self.request(Constants.article_url.NEWS_SITE2)
        } else if(Constants.article_url.NEWS_SITE3 != "") {
            self.request(Constants.article_url.NEWS_SITE3)
        }
        
        for item in self.items {
            self.articles.addObject(item)
        }
    }

    func request(url: NSString) {
        self.articles = Request.fetchFromNews(url as String, items: articles)
        self.loading = false
        let sort_descriptor1:NSSortDescriptor = NSSortDescriptor(key:"pudDate", ascending:false)
        let sorts = sort_descriptor1
        Snippet.sortDate(self.articles, count: self.articles.count)
    }
   
    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("Cell") as! NewsTableViewCell
        let item = self.articles[indexPath.row] as! NSDictionary
        
        return CellPreference.setValueToNewsViewCell(cell, item: item)
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.articles[indexPath.row] as! NSDictionary
        table.deselectRowAtIndexPath(indexPath, animated: true)
        if click_count % Constants.inter_ad.click_count == 0 {
            self.inter!.showTypeC(self)
        }
        
        TrackingManager.sendEventTracking("ブログ", action:"Push", label:"閲覧", value:NSNumber(), screen:"ニュース")
        click_count++;

        self.navigationController?.pushViewController( Snippet.setTapAction(item, mode: "blog"), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(self.table.contentOffset.y >= (self.table.contentSize.height - self.table.bounds.size.height) && self.loading == false) {
            SVProgressHUD.showWithStatus(Constants.message.LOADING)
            self.loading = true
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                sleep(1)
                SVProgressHUD.dismiss()
            })
        }
    }

}
