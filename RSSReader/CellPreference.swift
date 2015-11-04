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
        let imgURL: NSURL? = NSURL(string: item[Constants.article_data.IMAGE_URL] as! String)
        cell.movieImage.setImageWithURL(imgURL)
        
        return cell
    }
    
    class func setValueToNewsViewCell(cell: NewsTableViewCell, item: NSDictionary) -> NewsTableViewCell {
        cell.titleLabel.text = item[Constants.article_data.TITLE] as! NSString as String
        cell.dateLabel.text = item[Constants.news_json_key.pubDate] as! NSString as String
        cell.authorLabel.text = item[Constants.article_data.AUTHOR] as! NSString as String
        cell.titleLabel.numberOfLines = 2;
        
        return cell
    }
    
    
    class func setValueToBoardViewCell(cell: NewsTableViewCell, item: NSDictionary) -> NewsTableViewCell {
        cell.titleLabel.text = item[Constants.board.TITLE] as! NSString as String
        cell.dateLabel.text = item[Constants.board.LAST] as! NSString as String
        cell.authorLabel.text = ("投稿数 : " as String!)! + (item[Constants.board.POST] as! String)
        
        return cell
    }

    
    
    
    class func setValueToBlogViewCell(cell: BlogTableViewCell, item: NSDictionary) -> BlogTableViewCell {
       let image :UIImage = UIImage(named: "ima2.png")!
        cell.blogImage.image = image
        cell.titleLabel.text = item[Constants.article_data.TITLE] as! NSString as String
        cell.dateLabel.text = item[Constants.article_data.DATE] as! NSString as String
        cell.titleLabel.numberOfLines = 2;
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
    
}
