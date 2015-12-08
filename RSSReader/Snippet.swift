//
//  Snippet.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 9/2/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import Foundation

class Snippet {
 
    class func fetch(url_str: String, callback: (JSON, String?) -> Void) {
        var json : JSON!
        var requestbody = ""
        let url : NSURL = NSURL(string: url_str)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "GET"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
            data, responce, error in
            if error != nil {
            }
            json = JSON(data: data!)
            callback(json, nil)
        })
        task.resume()
    }
    class func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue()){
            block()
        }
    }
    
    class func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    class func appendData(item: Dictionary<String, String>, key: String, value:String) -> Dictionary<String, String> {
        let v = value
        var dic: Dictionary<String, String> = item
        if(!value.isEmpty) {
            dic[key] = v
        }
        return dic
    }
    
    
    
    class func sortDate(item: NSMutableArray, count: Int) -> NSMutableArray {
        for (var i = 0; i < (count - 1); i++) {
            for (var j = (count - 1); j > i; j--) {
                if ((item[j - 1][Constants.article_data.CREATED_AT] as! Int) < (item[j][Constants.article_data.CREATED_AT] as! Int)) {
                    let temp: AnyObject = item[j];
                    item[j] = item[j - 1];
                    item[j - 1] = temp;
                }
            }
        }
        return item
    }
    
    
    class func convertDate(day: NSString, news_name: NSString, callback: (NSDate, String?, String?)->Void ) {
        print("normalize 1")
        normalizeDateFormat1(day as String, callback: {
            (result, dateText, error) in
            if(error == nil) {
                print(result)
                print(dateText)
                callback(result, dateText, nil)
            }
        })
        print("normalize 2")
        normalizeDateFormat2(day as String, callback:{
           (result, dateText, error) in
            if(error == nil) {
                print(result)
                print(dateText)
                callback(result, dateText, nil)
            }
        })
        
        print("normalize 3")
        normalizeDateFormat3(day as String, callback: {
           (result, dateText, error) in
            if(error == nil) {
                print(result)
                print(dateText)
                callback(result, dateText, nil)
            }
        })
        print("normalize 4")
        normalizeDateFormat4(day as String, callback: {
           (result, dateText, error) in
            if(error == nil) {
                print(result)
                print(dateText)
                callback(result, dateText, nil)
            }
        })
    }
    
    // yyyy年mm月dd日 -> yyyy-MM-dd
    class func normalizeDateFormat1(day: String, callback:(NSDate, String?, String?) -> Void) {
        var yyy = day.componentsSeparatedByString("年")
        if(yyy.count == 1) {
            callback( NSDate(), nil, "error")
        } else {
            var mmm = yyy[1].componentsSeparatedByString("月")
            var ddd = mmm[1].componentsSeparatedByString("日")
            let created_at:String = (yyy[0] as String) + "-" + (mmm[0] as String) + "-" + (ddd[0] as String)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd";
            let dateOf2015_01_01_12_34_56 = dateFormatter.dateFromString(created_at as String)!;
            callback(NSDate(timeInterval: 60, sinceDate: dateOf2015_01_01_12_34_56), day, nil)
        }
    }
    
    // yyyy.mm.dd -> yyyy-MM-dd
    class func normalizeDateFormat2(day: String, callback: (NSDate, String?, String?) -> Void) {
        var yyy = day.componentsSeparatedByString(".")
        if(yyy.count == 1) {
            callback(NSDate(), nil, "error")
        } else {
            let created_at:String = (yyy[0] as String) + "-" + (yyy[1] as String) + "-" + (yyy[2] as String)
            let dateformat:String = (yyy[0] as String) + "年" + (yyy[1] as String) + "月" + (yyy[2] as String) + "日"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd";
            let dateOf2015_01_01_12_34_56 = dateFormatter.dateFromString(created_at as String)!;
            callback(NSDate(timeInterval: 60, sinceDate: dateOf2015_01_01_12_34_56), dateformat,nil)
        }
    }
    
    // 6:00 -> yyyy-MM-dd
    class func normalizeDateFormat3(day: String, callback: (NSDate, String?, String?) -> Void) {
        let yyy = day.componentsSeparatedByString(":")
        if(yyy.count == 1) {
            callback(NSDate(), nil, "error")
        } else {
            let now = NSDate() // 現在日時の取得
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // 日付フォーマットの設定
            let normalizeDateFormat = NSDateFormatter()
            normalizeDateFormat.dateFormat = "yyyy年MM月dd日" // 日付フォーマットの設定
            
            callback(now, normalizeDateFormat.stringFromDate(now), nil)
        }
    }
    
    // mm月dd日 -> yyyy-MM-dd
    class func normalizeDateFormat4(day: String, callback: (NSDate, String?, String?) -> Void) {
        let now = NSDate()
        var yyy = day.componentsSeparatedByString("月")
        if(yyy.count == 1) {
            callback(NSDate(), nil,"error")
        } else {
            var check = yyy[0].componentsSeparatedByString("年")
            print(check)
            if(check.count > 1) {
                 callback(NSDate(), nil, "error")
            } else {
                
                var ddd = yyy[1].componentsSeparatedByString("日")
                let normalizeDateFormat = NSDateFormatter()
                normalizeDateFormat.dateFormat = "yyyy" // 日付フォーマットの設定
                let created_at:String = normalizeDateFormat.stringFromDate(now) + "-" + (yyy[0] as String) + "-" + (ddd[0] as String)

                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd";
                let dateOf = dateFormatter.dateFromString(created_at as String)!;
                callback(NSDate(timeInterval: 60, sinceDate: dateOf), day, nil)

            }
        }
    }
    
    // Sun Nov 01 11:05:13 +0000 2015 -> yyyy-MM-dd HH:mm:ss
    class func normalizeDateFormat5(day: String) -> NSDate {
        var convertEnglishToMM: Dictionary<String, String> = ["Jan" : "1", "Feb" : "2", "Mar" : "3", "Apr" : "4", "May" : "5", "Jun" : "6",
            "Jul" : "7", "Aug" : "8", "Sep" : "9", "Oct" : "10", "Nov" : "11", "Dec" : "12"]
        var yyy = day.componentsSeparatedByString(" ")
        var MM = convertEnglishToMM[yyy[1]]
        var day = yyy[2]
        var time = yyy[3].componentsSeparatedByString(":")
        var hh = time[0]
        var mm = time[1]
        var ss = time[2]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        dateFormatter.locale = NSLocale.systemLocale()
        dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // 日付フォーマットの設定
        var data_formatter = (yyy.last)! + "-" + MM! + "-" + day + " " + hh + ":" + mm + ":" + ss
        let date = dateFormatter.dateFromString(data_formatter)!
        
        return date
    }
    

    class func convertDateformatToWhenAt(time: NSDate) -> String {
        let now:NSDate? = NSDate()
        
        let cal = NSCalendar.currentCalendar()
        let calUnit:NSCalendarUnit = [.Second, .Minute, .Hour, .Day, .Year]
        let components = cal.components(calUnit, fromDate: time, toDate: now!, options: [])
        
        if(components.year != 0)          { return String(components.year)   + "年前";
        } else if(components.day    != 0) { return String(components.day)    + "日前";
        } else if(components.hour   != 0) { return String(components.hour)   + "時間前";
        } else if(components.minute != 0) { return String(components.minute) + "分前";
        } else                            { return String(components.second) + "秒前"; }
    }
    
    class func isIncludeWord(search: NSMutableArray, word: NSString) -> Bool {
        for item in search {
            if(item[Constants.article_data.TITLE] as! NSString == word) {
                return false
            }
        }
        return true
    }
    
    class func setTapAction(item: NSDictionary, mode: String) -> KINWebBrowserViewController {
        let con = KINWebBrowserViewController()
        var URL: NSURL!
        
        if mode == "movie" {
            let youtube_url = "https://www.youtube.com/watch?v=" + (item[Constants.article_data.VIDEO_ID] as! String)
            URL = NSURL(string: youtube_url)
        } else {
            URL = NSURL(string: item[Constants.article_data.LINK] as! NSString as String)
        }
        con.loadURL(URL)
        
        return con
    }
}