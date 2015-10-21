//
//  DNAsset.h
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class ALAsset;
@interface DNAsset : NSObject

//  KTJ:    URL无法使用时候请使用源数据进行获取。《iOS8.3-iPhone6x会出现无法获取URL
@property (nonatomic, strong) ALAsset *alAsset;

@property (nonatomic, strong) NSURL *url;  //ALAsset url

- (BOOL)isEqualToAsset:(DNAsset *)asset;

@end
