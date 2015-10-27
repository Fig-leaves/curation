//
//  AdstirAdBase.h
//  AdstirAds
//
//  Copyright (c) 2012- UNITED, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

// Error code definition. / エラーコード
typedef enum : NSUInteger {
    // Timed out. / タイムアウト
    kAdstirAdErrorTimedOut = 100,
    // Invalid parameter. / 不正なパラメータ
    kAdstirAdErrorParameter = 200,
    // Network error. / ネットワークエラー
    kAdstirAdErrorNetwork = 300,
} AdstirAdError;

@class AdstirAdBase;

//
// Delegate protocol
// デリゲート
////////////////////////////////////////////////////////////////////////

@protocol AdstirAdDelegate <NSObject>
- (void)adstirAdDidReceived:(AdstirAdBase *)view;
- (void)adstirAdDidFailed:(AdstirAdBase *)view;
- (void)adstirAdDidError:(AdstirAdBase *)view WithCode:(AdstirAdError)code;
@end

@interface AdstirAdBase : UIView

//
// Spot settings / 広告スポットの設定
////////////////////////////////////////////////////////////////////////

// Set media ID. / メディアIDを設定します。
@property (copy) NSString *media;
// Set spot number. / 枠Noを設定します。
@property (nonatomic, assign) NSUInteger spot;


@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, weak) id<AdstirAdDelegate> delegate;
@property (nonatomic, assign) bool isCenter;

@property (nonatomic, assign) BOOL isScrollable;

// 位置情報を広告配信に利用する場合に使用します。
// エンドユーザーへの許諾無しに、位置情報を利用することはできません。
- (void)setLocationWithLatitude:(CGFloat)latitude
                      longitude:(CGFloat)longitude
                       accuracy:(CGFloat)accuracyInMeters;

@end

@interface AdstirAdpapriView : AdstirAdBase
@end

@interface AdstirRTBView : AdstirAdBase
@end

@interface AdstirAdserverView : AdstirAdBase
@end


