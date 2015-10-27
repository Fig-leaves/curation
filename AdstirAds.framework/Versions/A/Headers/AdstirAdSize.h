//
//  AdstirAdSize.h
//  AdstirAds
//
//  Copyright (c) 2014- UNITED, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct AdstirAdSize {
    CGSize size;
    NSUInteger flags;
} AdstirAdSize;

/** IAB Static Wide Banner (320 x 50). / バナー広告を表示します。 */
extern AdstirAdSize const kAdstirAdSize320x50;
/** IAB Static Intersitial (300 x 250). / レクタングル広告を表示します。 */
extern AdstirAdSize const kAdstirAdSize300x250;
/** Double Size Wide Banner (320 x 100). / ダブルサイズバナーを表示します。 */
extern AdstirAdSize const kAdstirAdSize320x100;
/**  */
extern AdstirAdSize const kAdstirAdSize728x90;

/** Create undefined AdstirAdSize from CGSize. / 未定義の広告サイズをCGSizeから作成します。 */
AdstirAdSize AdstirSizeFromCGSize(CGSize size);


BOOL AdstirAdSizeEqualToAdSize(AdstirAdSize size1, AdstirAdSize size2);
