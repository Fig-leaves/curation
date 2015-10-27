//
//  AdstirConfig.h
//  AdstirAds
//
//  Copyright (c) 2015 UNITED, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdstirConfig : NSObject

/**
 Turn SSL mode on / off
 SSLモードの有効/無効を切り替えます

 @param enabled
 */
+ (void)setSSLModeEnabled:(BOOL)enabled;

/**
 Get SSL mode status
 デバッグモードの状態を取得します
 */
+ (BOOL)SSLModeEnabled;

/**
 Turn debug mode on / off
 デバッグモードの有効/無効を切り替えます
 
 @param enabled 
 */
+ (void)setDebugModeEnabled:(BOOL)enabled;

/**
 Get debug mode status
 デバッグモードの状態を取得します
 */
+ (BOOL)debugModeEnabled;

@end
