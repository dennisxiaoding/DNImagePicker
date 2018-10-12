//
//  DNAsset.h
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(8.0) @interface DNAsset : NSObject

@property (nonatomic, copy) NSString *assetIdentifier;
@property (nonatomic, readonly) PHAsset *asset;

+ (DNAsset *)assetWithPHAsset:(PHAsset *)asset;


@end

NS_ASSUME_NONNULL_END
