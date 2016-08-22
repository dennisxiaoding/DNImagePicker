//
//  DNImageManager.h
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/28.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PHAsset;
@class PHImageRequestID;


@interface DNImageManager : NSObject

- (PHImageRequestID)fetchImageWithAsset:(PHAsset *)asset
                             targetSize:(CGSize)targetSize
                      imageResutHandler:(void (^)(UIImage *))handler;

- (PHImageRequestID)fetchImageWithAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize
            needHighQuality:(BOOL)isHighQuality
          imageResutHandler:(void (^)(UIImage *image))handler;
@end
