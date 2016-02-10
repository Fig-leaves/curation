//
//  CellPreference.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 9/15/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import Foundation

class CellPreference {
    class func setValueToYoutubeViewCell(cell: YoutubeTableViewCell, item: NSDictionary) -> YoutubeTableViewCell {
        let date = item[Constants.article_data.PUBLISH_AT] as! String
        let length = date.characters.count
        
        var startIndex:String.Index
        var endIndex:String.Index
        
        startIndex = date.startIndex.advancedBy(0)
        endIndex = date.startIndex.advancedBy(length - 14)
        let newString = date.substringWithRange(Range(start:startIndex ,end:endIndex))

        cell.movieTitleLabel.text = item[Constants.article_data.TITLE] as? String
        cell.movieTitleLabel.numberOfLines = 0;
        cell.movieTitleLabel.sizeToFit()
        cell.dateLabel.text = newString
        cell.dateLabel.textColor = UIColor(netHex: 0x808080)
        let imgURL: NSURL? = NSURL(string: item[Constants.article_data.IMAGE_URL] as! String)
        cell.movieImage.setImageWithURL(imgURL)
        
        return cell
    }
    
    
    class func setValueToWithImageViewCell(cell: YoutubeTableViewCell, item: NSDictionary) -> YoutubeTableViewCell {
        
        cell.movieTitleLabel.text = item[Constants.article_data.TITLE] as? String
        cell.movieTitleLabel.numberOfLines = 0;
        cell.movieTitleLabel.sizeToFit()
        cell.dateLabel.text = item["pubDate"] as! String
        cell.dateLabel.textColor = UIColor(netHex: 0x808080)
        let imgURL: NSURL? = NSURL(string: item[Constants.article_data.IMAGE_URL] as! String)
        cell.movieImage.setImageWithURL(imgURL)
        
        return cell
    }
    
    class func setValueToCharaViewCell(cell: CharaTableViewCell, item: NSDictionary) -> CharaTableViewCell {
        cell.titleLabel.text = item["title"] as! String
        cell.stageLabel.text = item["property1"] as! String
        cell.monsterLabel.text = item["property2"] as! String
        
        return cell
    }
    
    class func setValueToNewsViewCell(cell: NewsTableViewCell, item: NSDictionary) -> NewsTableViewCell {
        cell.titleLabel.text = item[Constants.article_data.TITLE] as! NSString as String
        cell.dateLabel.text = item[Constants.news_json_key.pubDate] as! NSString as String
        cell.authorLabel.text = item[Constants.article_data.AUTHOR] as! NSString as String
        cell.titleLabel.numberOfLines = 2;
        
        cell.authorLabel.textColor = UIColor(netHex: 0x808080)
        cell.dateLabel.textColor = UIColor(netHex: 0x808080)

        
        return cell
    }
    
    
    class func setValueToBoardViewCell(cell: NewsTableViewCell, item: NSDictionary) -> NewsTableViewCell {
        cell.titleLabel.text = item[Constants.board.TITLE] as! NSString as String
        cell.dateLabel.text = item[Constants.board.LAST] as! NSString as String
        cell.authorLabel.text = (item[Constants.board.POST] as! String)

//        cell.titleLabel.font = UIFont(name: "A-OTF-ShinGoPro-Light.otf", size: 17.0)
//        cell.authorLabel.font = UIFont(name: "A-OTF-ShinGoPro-Light.otf", size: 10.0)
//        cell.dateLabel.font = UIFont(name: "A-OTF-ShinGoPro-Light.otf", size: 10.0)
        
        cell.authorLabel.textColor = UIColor(netHex: 0x808080)
        cell.dateLabel.textColor = UIColor(netHex: 0x808080)

        return cell
    }
    
    class func setValueToBoardtype2ViewCell(cell: BoardTableViewCell, item: NSDictionary) -> BoardTableViewCell {
        cell.titleLabel.text = item[Constants.board.TITLE] as! NSString as String
//        cell.titleLabel.font = UIFont(name: "A-OTF-ShinGoPro-Light.otf", size: 16.0)
        
        return cell
    }


    
    class func setValueToBlogViewCell(cell: BlogTableViewCell, item: NSDictionary) -> BlogTableViewCell {
        let imgURL: NSURL? = NSURL(string: item["image"] as! String)
        cell.blogImage.setImageWithURL(imgURL)
        
        cell.titleLabel.text = item[Constants.article_data.TITLE] as! NSString as String
        cell.dateLabel.text = item[Constants.article_data.DATE] as! NSString as String
        cell.titleLabel.numberOfLines = 2;
        return cell
    }
    
    
    class func setValueToTrophyCell(cell: NewsTableViewCell, item: NSDictionary) -> NewsTableViewCell {
        cell.titleLabel.text = item["title"] as! String
        cell.authorLabel.text = item["rank"] as! String
        cell.dateLabel.text = item["pubDate"] as! String
        
        return cell
    }
    
    
    class func setValueToTicketViewCell(cell: TicketTableViewCell, items: NSMutableArray, indexPath: NSIndexPath) -> TicketTableViewCell {
        var str = items[indexPath.row][Constants.article_data.TITLE] as? String
        
        cell.titleLabel.text = items[indexPath.row][Constants.article_data.TITLE] as? String
        cell.placeLabel.text = items[indexPath.row][Constants.article_data.PLACE] as? String
        cell.closingLabel.text = items[indexPath.row][Constants.article_data.DATE] as? String
        
        if(items[indexPath.row][Constants.article_data.VALUE] != nil) {
            cell.valueLabel.text = items[indexPath.row][Constants.article_data.VALUE] as? String
        } else {
            cell.valueLabel.text = "詳細はこちら"
        }
        
        if(items[indexPath.row][Constants.article_data.IMAGE_URL] == nil) {
            let image :UIImage = UIImage(named: "ima2.png")!
            cell.ticketImage.image = image
        } else {
            let imgURL: NSURL? = NSURL(string: items[indexPath.row][Constants.article_data.IMAGE_URL] as! String)
            cell.ticketImage.setImageWithURL(imgURL)
        }
        cell.titleLabel.numberOfLines = 3;
        return cell
    }
    
    class func setValueToTweetCell(cell: TweetTableViewCell, item:NSDictionary) -> TweetTableViewCell {
        cell.nameLabel.text = item["name"] as! String
        cell.contentLabel.text = item["text"] as! String
        cell.screenNameLabel.text = item["whenAt"] as! String
        let imgURL: NSURL? = NSURL(string: item["profile_image_url"] as! String)
        cell.profile_image.setImageWithURL(imgURL)
        
        return cell
    }
    
}
