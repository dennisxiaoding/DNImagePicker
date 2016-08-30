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

@property (nonatomic, copy, nonnull) NSString *assetIdentifier;

- (void)fetchImageWithSize:(CGSize)size
           needHighQuality:(BOOL)highQuality
         imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler;

- (void)fetchImageWithSize:(CGSize)size
         imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler;


- (void)fetchImageSizeWithHandler:(void (^ _Nullable)(CGFloat imageSize,  NSString * _Nonnull sizeString))handler;

#if DNImagePikerPhotosAvaiable == 0

+ (DNAsset * _Nonnull)assetWithALAsset:(nullable ALAsset *)asset;

#else

+ (DNAsset * _Nonnull)assetWithPHAsset:(nullable PHAsset *)asset;

#endif

@end

NS_ASSUME_NONNULL_END