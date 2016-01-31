//
//  Constants.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 4/20/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import Foundation

struct Constants {
    struct article_url {
        static let NEWS_SITE1 = "https://www.kimonolabs.com/api/4i02mb1m?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
        static let NEWS_SITE2 = ""
        static let NEWS_SITE3 = ""
    }
    struct other_article_url {
        static let article2 = "https://www.kimonolabs.com/api/7itkrqjo?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
        static let article3 = "https://www.kimonolabs.com/api/dyrwfamm?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
        static let article4 = ""
        static let article5 = ""
    }
    
    struct trophy {
        static let URL = "https://www.kimonolabs.com/api/dbbslsq2?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
    }
    
    struct event_url {
        static let NEWS_SITE1 = "https://www.kimonolabs.com/api/dkrkdzl6?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
    }
    
    struct web_view {
        static let url = "http://www.apprank.kenjisugimoto.com/"
        static let url2 = "https://androider.jp/official/applist/ranking/total/daily/1/"
    }
    
    struct card_list {
        static let URL = "https://www.kimonolabs.com/api/bm8dptr0?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
    }
    
    struct ad {
        static let id = "MEDIA-ede54f7a"
        static let spot:UInt = 1
        static let ENABLE_VIEW = false

    }
    struct inter_ad {
        static let id = "MEDIA-ede54f7a"
        static let spot:UInt = 2
        static let click_count = 5
    }
    
    struct analytics {
        static let TRACK_ID = "UA-70168853-15"
    }
    
    struct blog {
        static let OFFICIAL_URL = "https://www.kimonolabs.com/api/eifrx42m?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
        static let OFFICIAL_URL2 = "https://www.kimonolabs.com/api/6e0bpwwk?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"

    }

    struct ticket {
        static let TICKET_URL = "https://www.kimonolabs.com/api/6atq0zuo?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
    }
    
    struct board_site {
        static let URL = "https://www.kimonolabs.com/api/a56b0dpu?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
        static let URL2 = "https://www.kimonolabs.com/api/3c87ii54?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
        static let URL3 = "https://www.kimonolabs.com/api/9yvwzxdi?apikey=O1LWGKfEhBnwnOmTTuxzTO5UiTYhLuLu"
    }
    
    struct youtube {
        static let API_KEY = "AIzaSyCcfEgQ_6qLIV5STXnZnLo040NzEmZuVZ4"
        static let WORD = "龍が如く極み 実況"
        static let RADIO = "Avicii LIVE"
        static let CHANNEL = "UC1SqP7_RfOC9Jf9L_GRHANg"
    }
    
    
    
    
    /* ここから先はいじらないでください */
    struct message {
        static let LOADING = "読み込み中..."
        static let UPDATING = "引っ張って更新"
    }
    
    struct title {
        static let BLOG = "ブログ"
        static let NEWS = "ニュース"
        static let MOVIE = "動画"
        static let OTHER = "その他"
        static let TICKET = "出演情報"
    }

    struct json_key {
        static let property1 = "property1"
        static let property2 = "property2"
        static let property3 = "property3"
    }
    
    struct article_data {
        static let TITLE = "title"
        static let LINK = "link"
        static let AUTHOR = "author"
        static let CREATED_AT = "created_at"
        static let DATE = "date"
        static let HREF = "href"
        static let TEXT = "text"
        static let PLACE = "place"
        static let VALUE = "value"
        static let WHEN = "when"
        static let IMAGE_URL = "image_url"
        static let VIDEO_ID = "videoId"
        static let PUBLISH_AT = "publishAt"
    }
    
    struct board {
        static let TITLE = "title"
        static let POST = "post"
        static let LAST = "last"
        static let LINK = "link"

    }


    struct frame {
        static let X = 10;
        static let Y = 420
        static let WIDTH = 660
        static let HEIGHT = 10
    }
    
    struct news_json_key {
        static let pubDate = "pubDate"
    }

}