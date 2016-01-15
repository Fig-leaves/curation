//
//  BoardViewController.swift
//  Curation
//
//  Created by 伊藤総一郎 on 11/2/15.
//  Copyright © 2015 susieyy. All rights reserved.
//

import UIKit

class BoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdstirMraidViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var articles = NSMutableArray()
    var refresh: UIRefreshControl!
    var loading = false
    var inter: AdstirInterstitial? = nil
    var click_count = 3

    var adView: AdstirMraidView? = nil
    deinit {
        // デリゲートを解放します。解放を忘れるとクラッシュする可能性があります。
        self.adView?.delegate = nil
        // 広告ビューを解放します。
        self.adView = nil
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        TrackingManager.sendScreenTracking("掲示板")

        self.inter = AdstirInterstitial()
        self.inter!.media = Constants.inter_ad.id
        self.inter!.spot = Constants.inter_ad.spot
        self.inter?.delegate = nil
        self.inter!.load()
        
        // NavigationControllerのタイトルバー(NavigationBar)の色の変更
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x000000)
        // NavigationConrtollerの文字カラーの変更
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // NavigationControllerのNavigationItemの色
        self.navigationController?.navigationBar.tintColor = UIColor.blackColor()

        self.title = "掲示板"
        
        articles = Request.fetchFromBoard(Constants.board_site.URL, items: articles)
        tableView.delegate = self
        tableView.dataSource = self

        let nibName = UINib(nibName: "NewsTableViewCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")

        // 広告表示位置: タブバーの下でセンタリング、広告サイズ: 320,50 の場合
        let originY = self.view.frame.height
        let originX = (self.view.frame.size.width - kAdstirAdSize320x50.size.width) / 2
        let adView = AdstirMraidView(adSize: kAdstirAdSize320x50, origin: CGPointMake(originX, originY - 100), media: Constants.ad.id, spot:Constants.ad.spot)
        // リフレッシュ秒数を設定します。
        adView.intervalTime = 5
        // デリゲートを設定します。
        adView.delegate = self
        if(Constants.ad.ENABLE_VIEW) {
            // 広告ビューを親ビューに追加します。
            self.view.addSubview(adView)
            self.adView = adView
        }
        

        
    }
    
    override func viewWillAppear(animated: Bool) {
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate //AppDelegate
        if appDelegate.eula == false {
            var alertController = UIAlertController(title: "利用規約に同意しますか？", message: "掲示板をご利用いただく前に利用規約やマナーに同意してください", preferredStyle: .Alert)
            
            let otherAction = UIAlertAction(title: "同意", style: .Default) {
                action in NSLog("はいボタンが押されました")
                appDelegate.eula = true
            }
            let readAction = UIAlertAction(title: "利用規約", style: .Default) {
                action in NSLog("はいボタンが押されました")
                let secondViewController: EulaViewController = self.storyboard?.instantiateViewControllerWithIdentifier("eula") as! EulaViewController
                
                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            
            let cancelAction = UIAlertAction(title: "同意しない", style: .Cancel) {
                action in NSLog("いいえボタンが押されました")
            }
            
            // addActionした順に左から右にボタンが配置されます
            alertController.addAction(otherAction)
            alertController.addAction(readAction)
            alertController.addAction(cancelAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! NewsTableViewCell
        let item = self.articles[indexPath.row] as! NSDictionary
        
        return CellPreference.setValueToBoardViewCell(cell, item: item)
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.articles[indexPath.row] as! NSDictionary
        tableView?.deselectRowAtIndexPath(indexPath, animated: true)

        if click_count % Constants.inter_ad.click_count == 0 {
            self.inter!.showTypeC(self)
        }
        click_count++;
        TrackingManager.sendEventTracking("Board", action:"Push", label:"閲覧", value:NSNumber(), screen:"掲示板")


        self.navigationController?.pushViewController( Snippet.setTapAction(item, mode: "blog"), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height) && self.loading == false) {
            SVProgressHUD.showWithStatus(Constants.message.LOADING)
            self.loading = true
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                sleep(1)
                SVProgressHUD.dismiss()
            })
        }
    }

}
