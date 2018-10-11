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

@property (nonatomic, copy) NSString *assetIdentifier;
@property (nonatomic, readonly) PHAsset *asset;

+ (DNAsset *)assetWithPHAsset:(PHAsset *)asset NS_AVAILABLE_IOS(8_0);


@end

NS_ASSUME_NONNULL_END
