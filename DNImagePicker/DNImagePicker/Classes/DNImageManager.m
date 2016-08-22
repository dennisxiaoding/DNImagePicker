//
//  DNImageManager.m
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/28.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNImageManager.h"
#import "DNImagePicker.h"

@implementation DNImageManager

- (PHImageRequestID)fetchImageWithAsset:(PHAsset *)asset
                             targetSize:(CGSize)targetSize
                      imageResutHandler:(void (^)(UIImage *))handler {
    return  [self fetchImageWithAsset:asset targetSize:targetSize needHighQuality:NO imageResutHandler:handler];
}

- (PHImageRequestID)fetchImageWithAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize
            needHighQuality:(BOOL)isHighQuality
          imageResutHandler:(void (^)(UIImage *image))handler {
    if (!asset) {
        return PHInvalidImageRequestID;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    if (isHighQuality) {
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    } else {
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
    }
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
    return [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                             targetSize:size
                                                            contentMode:PHImageContentModeAspectFill
                                                                options:options
                                                          resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                              handler(result);
                                                          }];
}

@end
