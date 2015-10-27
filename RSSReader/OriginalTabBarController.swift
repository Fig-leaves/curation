//
//  OriginalTabBarController.swift
//  RSSReader
//
//  Created by 伊藤総一郎 on 3/25/15.
//  Copyright (c) 2015 susieyy. All rights reserved.
//

import UIKit

class OriginalTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // あらかじめ色とフォントファミリーを指定
        let colorKey = UIColor(red: 255/255, green: 158/255, blue: 35/255, alpha: 1.0)
        let colorBg = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        let fontFamily: UIFont! = UIFont(name: "Hiragino Kaku Gothic ProN",size:10)
        
        // 文字色とフォント変えたい
        let selectedAttributes: [String : AnyObject]! = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: colorKey]
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, forState: UIControlState.Selected)
        
        // アイコンの色変えたい
        UITabBar.appearance().tintColor = colorKey
        
        // 背景色変えたい
        UITabBar.appearance().barTintColor = colorBg
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
