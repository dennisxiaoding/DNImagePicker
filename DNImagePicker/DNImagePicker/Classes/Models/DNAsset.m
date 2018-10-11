//
//  DNAsset.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "DNAsset.h"
#import "DNImagePickerHelper.h"
@interface DNAsset ()

@property (nonatomic, strong, nullable) PHAsset *asset;
@property (nonatomic, assign) PHImageRequestID requestID;

@property (nonatomic, strong, nullable) ALAsset *alAssets;

///the size of the file for this representation
@property (nonatomic, assign) NSInteger imageSize;

@end

@implementation DNAsset

+ (DNAsset *)assetWithALAsset:(ALAsset *)asset {
    DNAsset *a = [[DNAsset alloc] init];
    id url = [asset valueForProperty:ALAssetPropertyAssetURL];
    if ([url isKindOfClass:[NSURL class]]) {
        a.assetIdentifier = ((NSURL *)url).absoluteString;
    } else if ([url isKindOfClass:[NSString class]]) {
        a.assetIdentifier = (NSString *)url;
    }
    a.imageSize = (NSInteger)asset.defaultRepresentation.size/1024;
    a.alAssets = asset;
    return a;
}

+ (DNAsset *)assetWithPHAsset:(PHAsset *)asset {
    DNAsset *a = [[DNAsset alloc] init];
    a.asset = asset;
    a.assetIdentifier = asset.localIdentifier;
    return a;
}

- (void)cancelImageRequest {
    if (@available(iOS 8.0, *)) {
        [DNImagePickerHelper cancelFetchWithAssets:self.asset];
    }
}

- (void)fetchImageWithSize:(CGSize)size
         imageResutHandler:(void (^)(UIImage *image))handler {
    [self fetchImageWithSize:size needHighQuality:NO imageResutHandler:handler];
}

- (void)fetchImageWithSize:(CGSize)size
           needHighQuality:(BOOL)highQuality
         imageResutHandler:(void (^)(UIImage *image))handler {
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

- (void)fetchImageSizeWithHandler:(void (^)(CGFloat imageSize, NSString *sizeString))handler {
    if (@available(iOS 8.0, *)) {
        [DNImagePickerHelper fetchImageSizeWithAsset:self.asset
                              imageSizeResultHandler:^(CGFloat imageSize, NSString *sizeString) {
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
