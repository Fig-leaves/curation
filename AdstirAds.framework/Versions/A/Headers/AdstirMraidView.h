//
//  AdstirMraidView.h
//  AdstirAds
//
//  Copyright (c) 2013- UNITED, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AdstirAdSize.h"

// Don't refresh. / ローテーション無効
#define ADSTIRWEBVIEW_NO_INTERVAL 0
// Minimum refresh interval. / 最小のローテーション感覚
#define ADSTIRWEBVIEW_MIN_INTERVAL 30
// Default refresh interval. / デフォルトのローテーション時間
#define ADSTIRWEBVIEW_DEFAULT_INTERVAL 60

@class AdstirMraidView;

//
// Delegate protocol
// デリゲート
////////////////////////////////////////////////////////////////////////
@protocol AdstirMraidViewDelegate <NSObject>
@optional
- (void)adstirMraidViewWillPresentScreen:(AdstirMraidView *)mraidView;
- (void)adstirMraidViewDidPresentScreen:(AdstirMraidView *)mraidView;
- (void)adstirMraidViewWillDismissScreen:(AdstirMraidView *)mraidView;
- (void)adstirMraidViewWillLeaveApplication:(AdstirMraidView *)mraidView;
@end

//
// AdstirMraidView
////////////////////////////////////////////////////////////////////////
@interface AdstirMraidView : UIView

// Set refresh time in seconds. / ローテーション時間(秒)を設定します。
@property (assign) NSUInteger  intervalTime;
// Set delegate. / デリゲートを設定します。
@property (weak) id<AdstirMraidViewDelegate> delegate;


// Initialize with origin (0, 0) to parent view. / 親ビューの左上を起点として初期化します。
- (id)initWithAdSize:(AdstirAdSize)size media:(NSString *)media spot:(NSUInteger)spot;
// Initialize with custome origin to parent view. / 親ビューに対する位置を指定して初期化します。
- (id)initWithAdSize:(AdstirAdSize)size origin:(CGPoint)origin media:(NSString *)media spot:(NSUInteger)spot;

// 位置情報を広告配信に利用する場合に使用します。
// エンドユーザーへの許諾無しに、位置情報を利用することはできません。
- (void)setLocationWithLatitude:(CGFloat)latitude
                      longitude:(CGFloat)longitude
                       accuracy:(CGFloat)accuracyInMeters;

// Start loading. / 読み込みを開始します。
- (void)start;
// Stop loading. / 読み込みを停止します。
- (void)stop;
@end
