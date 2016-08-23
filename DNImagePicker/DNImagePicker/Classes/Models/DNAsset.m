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

#if DNImagePikerPhotosAvaiable == 1

@property (nonatomic, strong, nonnull) PHAsset *asset;

#endif

@end

@implementation DNAsset

#if DNImagePikerPhotosAvaiable == 0


#else
+ (DNAsset  * _Nonnull )assetWithPHAsset:(nullable PHAsset *)asset {
    DNAsset *a = [[DNAsset alloc] init];
    a.asset = asset;
    a.assetIdentifier = asset.localIdentifier;
    return a;
}

#endif


- (void)fetchImageWithSize:(CGSize)size
         imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler {
    [self fetchImageWithSize:size needHighQuality:NO imageResutHandler:handler];
}

- (void)fetchImageWithSize:(CGSize)size
           needHighQuality:(BOOL)highQuality
         imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler {
    [DNImagePickerHelper fetchImageWithAsset:self.asset
                                  targetSize:size
                             needHighQuality:highQuality
                           imageResutHandler:^(UIImage * _Nullable image) {
                               handler(image);
                           }];
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
