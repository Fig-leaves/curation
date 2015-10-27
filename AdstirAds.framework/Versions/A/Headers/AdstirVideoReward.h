//
//  AdstirRewardVideo.h
//  AdstirAds
//
//  Copyright (c) 2015 UNITED, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AdstirVideoRewardErrorNoFill,
    AdstirVideoRewardErrorInvalidSpot,
    AdstirVideoRewardErrorUnknown,
} AdstirVideoRewardError;

@class AdstirVideoReward;

@protocol AdstirVideoRewardDelegate <NSObject>

@optional
/**
 動画の再生準備が完了した際に呼び出されます
 */
- (void)adstirVideoRewardDidLoad:(AdstirVideoReward *)videoReward;
/**
 動画の再生準備に失敗した際に呼び出されます
 */
- (void)adstirVideoReward:(AdstirVideoReward *)videoReward didFailToLoadWithError:(NSError *)error;
/**
 動画の再生が開始された際に呼び出されます
 */
- (void)adstirVideoRewardDidStart:(AdstirVideoReward *)videoReward;
/**
 動画の再生が完了し、リワードが付与された際に呼び出されます
 */
- (void)adstirVideoRewardDidComplete:(AdstirVideoReward *)videoReward;
/**
 動画の再生が完了し、動画再生画面が閉じられたときに呼び出されます
 */
- (void)adstirVideoRewardDidClose:(AdstirVideoReward *)videoReward;
/**
 動画の再生がキャンセルされた際に呼び出されます
 ただし、このイベントには全てのアドネットワークが対応しているわけではありません
 */
- (void)adstirVideoRewardDidCancel:(AdstirVideoReward *)videoReward;

@end


@interface AdstirVideoReward : NSObject

@property (copy) NSString *media;
@property (assign) NSUInteger *spot;

@property (assign, readonly) BOOL isPlaying;

@property (weak) id<AdstirVideoRewardDelegate> delegate;

@property (copy, readonly) NSString *rewardCurrency;
@property (copy, readonly) NSString *rewardAmount;

+ (void)setMediaUserID:(NSString *)mediaUserID;
+ (NSString *)mediaUserID;

+ (void)prepareWithMedia:(NSString *)media spots:(NSArray *)spots;

- (instancetype)initWithMedia:(NSString *)media spot:(NSUInteger)spot;

- (void)load;

- (void)show;

@end
