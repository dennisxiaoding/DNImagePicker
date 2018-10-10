//
//  DNAlbum.h
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNAlbum : NSObject

+ (DNAlbum * _Nonnull)albumWithAssetCollection:(PHAssetCollection * _Nonnull)collection
                                         results:(PHFetchResult * _Nonnull)results NS_AVAILABLE_IOS(8_0);

@property (nonatomic, strong, nullable) NSDate *startDate NS_AVAILABLE_IOS(8_0);

/*
 @note use this model to store the album's 'result, 'count, 'name, 'startDate
 to avoid request and reserve too much times.
 */
@property (nonatomic, strong, nullable) PHFetchResult *results  NS_AVAILABLE_IOS(8_0);

@property (nonatomic, copy, nullable) NSString *identifier;

@property (nonatomic, copy, nonnull) NSString *albumTitle;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, readonly, nonnull) NSAttributedString *albumAttributedString;

- (void)fetchPostImageWithSize:(CGSize)size imageResutHandler:(void (^ _Nullable)(UIImage * _Nullable))handler;

+ (DNAlbum * _Nonnull)albumWithAssetGroup:(ALAssetsGroup *)assetGroup NS_DEPRECATED_IOS(4_0, 9_0);

@property (nonatomic, copy, nullable) NSString *albumPropertyType NS_DEPRECATED_IOS(4_0, 9_0);

@property (nonatomic, strong) UIImage *posterImage  NS_DEPRECATED_IOS(4_0, 9_0);

@end


NS_ASSUME_NONNULL_END
