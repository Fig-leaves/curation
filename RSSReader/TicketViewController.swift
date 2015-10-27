//
//  TwitterViewController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/9/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate {
    
    var items = NSMutableArray()
    var refresh: UIRefreshControl!
    @IBOutlet weak var table: UITableView!
    var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        let nibName = UINib(nibName: "TicketTableViewCell", bundle:nil)
        table.registerNib(nibName, forCellReuseIdentifier: "Cell")
        items = NSMutableArray()

        table.delegate = self
        table.dataSource = self
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: Constants.message.UPDATING)
        self.refresh.addTarget(self, action: Selector("reload"), forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(refresh)
        self.title = Constants.title.TICKET

        // NADViewクラスを生成
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
        // Dispose of any resources that can be recreated.
    }
    func reload() {
        items = NSMutableArray()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.request()
            self.refresh?.endRefreshing()
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        items = NSMutableArray()

        SVProgressHUD.showWithStatus(Constants.message.LOADING)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.request()
            SVProgressHUD.dismiss()
        })
    }
    
    func request() {
        var urlString:String = Constants.ticket.TICKET_URL
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
        var json = JSON(dic)

        var content : Dictionary<String, String> = ["" : ""]
        for (index: String, subJson: mySubJson) in json["results"]["collection1"] {
            content = Snippet.appendData(content, key: Constants.article_data.TITLE, value: mySubJson["title"]["text"].stringValue)
            content = Snippet.appendData(content, key: Constants.article_data.HREF, value: mySubJson["title"][Constants.article_data.HREF].stringValue)
            content = Snippet.appendData(content, key: Constants.article_data.VALUE, value: mySubJson["value"]["text"].stringValue)
            content = Snippet.appendData(content, key: Constants.article_data.PLACE, value: mySubJson["place"]["text"].stringValue)
            content = Snippet.appendData(content, key: Constants.article_data.DATE, value: mySubJson["date"]["text"].stringValue)
            content = Snippet.appendData(content, key: Constants.article_data.IMAGE_URL, value: mySubJson["image"]["src"].stringValue)
            content = Snippet.appendData(content, key: Constants.article_data.WHEN, value: mySubJson["when"].stringValue)
            
            self.items.addObject(content)
        }
        self.table.reloadData()
        
    }
    
    func tableView(table: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSectionsInTableView(table: UITableView) -> Int {
        return 1
    }
    
    func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCellWithIdentifier("Cell") as! TicketTableViewCell
        
        CellPreference.setValueToTicketViewCell(cell, items: self.items, indexPath: indexPath)

        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let con = KINWebBrowserViewController()
        let URL = NSURL(string:  self.items[indexPath.row][Constants.article_data.HREF] as! String)
        con.loadURL(URL)
        self.navigationController?.pushViewController(con, animated: true)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(self.table.contentOffset.y >= (self.table.contentSize.height - self.table.bounds.size.height)
            && loading == false) {
                loading = true
                SVProgressHUD.showWithStatus(Constants.message.LOADING)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SVProgressHUD.dismiss()
                })
        }
    }

}