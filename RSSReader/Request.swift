//
//  Request.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 9/15/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import Foundation

class Request {
    class func fetchFromYoutube(next: Bool, word: String, nextPageToken:String, items: NSMutableArray,callback: (NSMutableArray, String) -> Void) {
        var token = nextPageToken
        let API_KEY = Constants.youtube.API_KEY
        let searchWord:String! = word.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var urlString:String
        if(next) {
            urlString = "https://www.googleapis.com/youtube/v3/search?key=\(API_KEY)&q=\(searchWord)&part=snippet&pageToken=\(nextPageToken)&maxResults=20&order=viewCount"
        } else {
            urlString = "https://www.googleapis.com/youtube/v3/search?key=\(API_KEY)&q=\(searchWord)&part=snippet&maxResults=20&order=viewCount"
        }
        let url:NSURL! = NSURL(string:urlString)
        let urlRequest:NSURLRequest = NSURLRequest(URL:url)
        
        var data:NSData
        var dic: NSDictionary = NSDictionary()
//        let dic:NSDictionary
        
        do {
            data = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: nil)
            dic = try NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        } catch {
            print("ERROR")
        }
        if(dic.objectForKey("nextPageToken") != nil) {
            token = dic.objectForKey("nextPageToken") as! String
        } else {
            token = "nil"
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
                items.addObject(content)
            }
            callback(items, token)
        })
    }
    
    class func fetchFromNews(url: String, items:NSMutableArray) -> NSMutableArray {
        var urlString:String
        urlString = url as String
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
        
        
        
        var news_name = dic.objectForKey("name") as! NSString
        let result: NSDictionary = dic.objectForKey("results") as! NSDictionary
        let itemsArray: NSArray = result.objectForKey("collection1") as! NSArray
        var content: Dictionary<String, AnyObject> = ["" : ""]

        itemsArray.enumerateObjectsUsingBlock({ object, index, stop in
            
            if let news = object.objectForKey("property1") as? NSDictionary {
                content[Constants.article_data.TITLE] = news.objectForKey(Constants.article_data.TEXT) as! NSString
                content[Constants.article_data.LINK] = news.objectForKey(Constants.article_data.HREF) as! NSString
            } else {
                content[Constants.article_data.TITLE] = object.objectForKey("property1") as! NSString
                content[Constants.article_data.LINK] = object.objectForKey("url") as! NSString
            }
            
            if let news = object.objectForKey("news_name") as? NSDictionary {
                news_name = news.objectForKey(Constants.article_data.TEXT) as! NSString
            } 
            
            
            
            
            if(object.objectForKey("source") is NSDictionary) {
                var source = object.objectForKey("source") as! NSDictionary
                content[Constants.article_data.AUTHOR] = source.objectForKey(Constants.article_data.TEXT) as! NSString
            } else {
                content[Constants.article_data.AUTHOR] = news_name
            }
            
            var day:NSString!
            if(object.objectForKey(Constants.news_json_key.pubDate) is NSDictionary) {
                var date = object.objectForKey(Constants.news_json_key.pubDate) as! NSDictionary
                day = date.objectForKey(Constants.article_data.TEXT) as! NSString
            } else {
                day = object.objectForKey(Constants.news_json_key.pubDate) as! NSString;
            }
            Snippet.convertDate(day, news_name: news_name)  {
                (result, dateFormat,error) in
                if(error == nil) {
                    content[Constants.article_data.CREATED_AT] = result.timeIntervalSinceNow
                    content[Constants.news_json_key.pubDate] = dateFormat
                    items.addObject(content)
                }
            }
        })
        return items
    }
 
    class func fetchFromBlog(url: String, callback: (NSMutableArray) -> Void) {
        var items = NSMutableArray()
        Snippet.fetch( url, callback: {
            (data, error) in
            var content : Dictionary<String, String> = ["" : ""]
            for (index: _, subJson: mySubJson) in data["results"]["collection1"] {
                content[Constants.article_data.TITLE] = mySubJson[Constants.json_key.property1][Constants.article_data.TEXT].stringValue
                content[Constants.article_data.HREF] = mySubJson[Constants.json_key.property1][Constants.article_data.HREF].stringValue
                if(mySubJson[Constants.json_key.property2] != nil) {
                    content[Constants.article_data.DATE] = mySubJson[Constants.json_key.property2].stringValue
                } else {
                    content[Constants.article_data.DATE] = ""
                }
                print(content)
                items.addObject(content)
            }
            callback(items)
        })
    }
}
