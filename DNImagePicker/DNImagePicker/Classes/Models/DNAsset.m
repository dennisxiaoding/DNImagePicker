//
//  DNAsset.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"
#import "DNImagePickerHelper.h"
@interface DNAsset ()

@property (nonatomic, strong, nonnull) PHAsset *asset;
@property (nonatomic, assign) PHImageRequestID requestID;

@property (nonatomic, strong, nonnull) ALAsset *alAssets;

///the size of the file for this representation
@property (nonatomic, assign) NSInteger imageSize;

@end

@implementation DNAsset

+ (DNAsset *)assetWithALAsset:(ALAsset *)asset {
    DNAsset *a = [[DNAsset alloc] init];
    a.assetIdentifier = [asset valueForProperty:ALAssetPropertyAssetURL];
    a.imageSize = asset.defaultRepresentation.size/1024;
    a.alAssets = asset;
    return a;
}

+ (DNAsset * _Nonnull)assetWithPHAsset:(nullable PHAsset *)asset {
    DNAsset *a = [[DNAsset alloc] init];
    a.asset = asset;
    a.assetIdentifier = asset.localIdentifier;
    return a;
}

- (void)cancelImageRequest {
    [DNImagePickerHelper cancelFetchWithAssets:self.asset];
}

- (void)fetchImageWithSize:(CGSize)size
         imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler {
    [self fetchImageWithSize:size needHighQuality:NO imageResutHandler:handler];
}

- (void)fetchImageWithSize:(CGSize)size
           needHighQuality:(BOOL)highQuality
         imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler {
    if (@available(iOS 8.0, *)) {
        [DNImagePickerHelper fetchImageWithAsset:self.asset
                                      targetSize:size
                                 needHighQuality:highQuality
                               imageResutHandler:^(UIImage * _Nullable image) {
                                   handler(image);
                               }];
    }else {
        UIImage *image;
        if (highQuality) {
            image = [UIImage imageWithCGImage:self.alAssets.defaultRepresentation.fullScreenImage];
        } else {
            image = [UIImage imageWithCGImage:self.alAssets.thumbnail];
        }
        handler(image);
    }
}

- (void)fetchImageSizeWithHandler:(void (^ _Nullable)(CGFloat imageSize,  NSString * _Nonnull sizeString))handler {
    if (@available(iOS 8.0, *)) {
        [DNImagePickerHelper fetchImageSizeWithAsset:self.asset
                              imageSizeResultHandler:^(CGFloat imageSize, NSString * _Nonnull sizeString) {
                                  handler(imageSize, sizeString);
                              }];
    } else {
        NSString *string = @"0M";
        if (self.imageSize > 1024*1024) {
            CGFloat size = self.imageSize/(1024.0*2024.0);
            string = [NSString stringWithFormat:@"%.1fM",size];
        } else {
            CGFloat size = self.imageSize/1024.0;
            string = [NSString stringWithFormat:@"%.1fK",size];
        }
        handler(self.imageSize, string);
    }
}

- (PHAsset *)fetchAsset {
    return self.asset;
}

- (void)setRequestID:(PHImageRequestID)requesetID {
    _requestID = requesetID;
}

- (void)resetRequestID {
    self.requestID = PHInvalidImageRequestID;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        if ([other isKindOfClass:[DNAsset class]]) {
            return [self.assetIdentifier isEqualToString:other];
        } else {
            return NO;
        }
    }
}

@end
