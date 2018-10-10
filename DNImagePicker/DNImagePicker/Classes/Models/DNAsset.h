//
//  DNAsset.h
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNAsset : NSObject

@property (nonatomic, copy, nullable) NSString *assetIdentifier;

- (void)fetchImageWithSize:(CGSize)size
           needHighQuality:(BOOL)highQuality
         imageResutHandler:(void (^)(UIImage * image))handler;

- (void)fetchImageWithSize:(CGSize)size
         imageResutHandler:(void (^)(UIImage * image))handler;


- (void)fetchImageSizeWithHandler:(void (^)(CGFloat imageSize, NSString *sizeString))handler;

+ (DNAsset *)assetWithALAsset:(ALAsset *)asset NS_DEPRECATED_IOS(4_0, 9_0);

+ (DNAsset *)assetWithPHAsset:(PHAsset *)asset NS_AVAILABLE_IOS(8_0);

- (void)cancelImageRequest;

@end

NS_ASSUME_NONNULL_END
