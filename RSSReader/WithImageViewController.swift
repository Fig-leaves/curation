import UIKit

class WithImageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AdstirMraidViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var items = NSMutableArray()
    var refresh: UIRefreshControl!
    final let API_KEY = Constants.youtube.API_KEY
    final let WORD:String = Constants.youtube.WORD
    var loading = false
    var nextPageToken:NSString!
    var inter: AdstirInterstitial? = nil
    var click_count = 0;
    var kimono_url:String = ""
    var title_str:String = ""
    
    var adView: AdstirMraidView? = nil
    deinit {
        
        // デリゲートを解放します。解放を忘れるとクラッシュする可能性があります。
        self.adView?.delegate = nil
        // 広告ビューを解放します。
        self.adView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.title_str
        
        TrackingManager.sendScreenTracking("今週の献立")
        
        self.inter = AdstirInterstitial()
        self.inter!.media = Constants.inter_ad.id
        self.inter!.spot = Constants.inter_ad.spot
        self.inter?.delegate = nil
        self.inter!.load()
        
        
        // 広告表示位置: タブバーの下でセンタリング、広告サイズ: 320,50 の場合
        let originY = self.view.frame.height
        let originX = (self.view.frame.size.width - kAdstirAdSize320x100.size.width) / 2
        let adView = AdstirMraidView(adSize: kAdstirAdSize320x100, origin: CGPointMake(originX, originY - 100), media: Constants.ad.id, spot:Constants.ad.spot)
        
        adView.intervalTime = 3
        adView.delegate = self
        
        if(Constants.ad.ENABLE_VIEW) {
            // 広告ビューを親ビューに追加します。
            self.view.addSubview(adView)
            self.adView = adView
        }
        
        self.nextPageToken = "nil"
        self.navigationController?.navigationBar.barTintColor = UIColor(netHex: 0x000000)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        items = NSMutableArray()
        let nibName = UINib(nibName: "YoutubeTableViewCell", bundle:nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.refresh = UIRefreshControl()
        self.refresh.attributedTitle = NSAttributedString(string: Constants.message.UPDATING)
        self.refresh.addTarget(self, action: "viewWillAppear:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresh)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        items = NSMutableArray()
        request(false)
        self.adView?.start()
        
        self.refresh?.endRefreshing()
    }
    
    func request(next: Bool) {
        if self.kimono_url == "" {
            print("kimono url is null")
            items = Request.fetchFromWithImage(Constants.article_url.NEWS_SITE3, items: items)
        } else {
            print("kimono url is not empty")
            items = Request.fetchFromWithImage(self.kimono_url, items: items)
        }
        self.tableView.reloadData()
        self.loading = false
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! YoutubeTableViewCell
        let item = self.items[indexPath.row] as! NSDictionary
        
        return CellPreference.setValueToWithImageViewCell(cell, item: item)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.items[indexPath.row] as! NSDictionary
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        TrackingManager.sendEventTracking("Youtube", action:"Push", label:"閲覧", value:NSNumber(), screen:"プレイ動画")
        
        if click_count % Constants.inter_ad.click_count == 0 {
            self.inter!.showTypeC(self)
        }
        click_count++;
        self.navigationController?.pushViewController(Snippet.setTapAction(item, mode: "blog"), animated: true)
        
    }
}