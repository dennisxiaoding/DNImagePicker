//
//  DNImageManager.m
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/28.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNImageManager.h"

@implementation DNImageManager

- (PHImageRequestID)fetchImageWithAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize
            needHighQuality:(BOOL)isHighQuality
          imageResutHandler:(void (^)(UIImage *image))handler {
    if (!asset) {
        return 0;
    }
    return 0；
}


@end
