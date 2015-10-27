//
//  AdstirNativeAd.h
//  AdstirAds
//
//  Copyright (c) 2014- UNITED, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AdstirNativeAd;

// Define the Delegate .
@protocol AdstirLoadSmallImageDeledate <NSObject>
// Performed when load small image.
- (void)adstirDidLoadSmallImage:(NSData *) data;
// Performed when fail to load small image.
- (void)adstirDidFailToLoadSmallImage;
@end

// Define the Delegate .
@protocol AdstirLoadImageDeledate <NSObject>
// Performed when load image.
- (void)adstirDidLoadImage:(NSData *) data;
// Performed when fail to load image.
- (void)adstirDidFailToLoadImage;
@end

@interface AdstirNativeAdResponse : NSObject

@property (nonatomic, weak) id<AdstirLoadSmallImageDeledate> loadSmallImageDelegate;
@property (nonatomic, weak) id<AdstirLoadImageDeledate> loadImageDelegate;

@property (nonatomic, readonly, copy) NSString* smallImageUrl;
@property (nonatomic, readonly, copy) NSString* imageUrl;
@property (nonatomic, readonly, copy) NSString* cta;
@property (nonatomic, readonly, copy) NSString* landingPageUrl;
@property (nonatomic, readonly, copy) NSString* title;
@property (nonatomic, readonly, copy) NSString* descriptionText;
@property (nonatomic, readonly, assign) float rating;
- (void)impression;
- (void)click;

+ (void)bindImageWithURL:(NSURL *)url bindCallback:(void (^) (UIImage *image))callback;

- (void)bindImageToImageView:(UIImageView *)imageView;
- (void)bindSmallImageToImageView:(UIImageView *)imageView;

- (void)bindImageToButton:(UIButton *)button;
- (void)bindSmallImageToButton:(UIButton *)button;

// Call by user to get the byte data of small image.
- (void)getSmallImageAsByte;
// Call by user to get the byte data of image.
- (void)getImageAsByte;

@end


@protocol AdstirNativeAdDelegate <NSObject>

// Performed when receive ad. / 広告が取得できた際に呼び出されます。
- (void)adstirNativeAdDidReceiveAd:(AdstirNativeAd*)nativeAd response:(AdstirNativeAdResponse*)response;
// Performed when fail to receive ad. / 広告が取得できなかった際に呼び出されます。
- (void)adstirNativeAdDidFailToReceiveAd:(AdstirNativeAd*)nativeAd;

@end

@interface AdstirNativeAd : NSObject {
    int endPoint;
}
@property (nonatomic, weak) id<AdstirNativeAdDelegate> delegate;
// Set media ID. / メディアIDを設定します。
@property (nonatomic, copy) NSString *media;
// Set spot number. / 枠Noを設定します。
@property (nonatomic, assign) NSUInteger spot;

@property (nonatomic, copy) NSString *sponsoredText;

@property (nonatomic, assign) NSUInteger titleLength        __attribute__ ((deprecated));
@property (nonatomic, assign) NSUInteger descriptionLength  __attribute__ ((deprecated));
@property (nonatomic, assign) NSUInteger ctaLength          __attribute__ ((deprecated));
@property (nonatomic, assign) BOOL image                    __attribute__ ((deprecated));
@property (nonatomic, assign) BOOL smallImage               __attribute__ ((deprecated));
@property (nonatomic, assign) BOOL rating                   __attribute__ ((deprecated));
@property (nonatomic, assign) BOOL landingPageUrl           __attribute__ ((deprecated));

// 位置情報を広告配信に利用する場合に使用します。
// エンドユーザーへの許諾無しに、位置情報を利用することはできません。
- (void)setLocationWithLatitude:(CGFloat)latitude
                      longitude:(CGFloat)longitude
                       accuracy:(CGFloat)accuracyInMeters;

- (void)getAd;

@end


