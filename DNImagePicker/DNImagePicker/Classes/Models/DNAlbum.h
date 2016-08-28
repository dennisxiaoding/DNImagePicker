//
//  DNAlbum.h
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNImagePicker.h"

NS_ASSUME_NONNULL_BEGIN

@interface DNAlbum : NSObject

#if DNImagePikerPhotosAvaiable == 1

+ (DNAlbum * _Nonnull)albumWithAssetCollection:(PHAssetCollection * _Nonnull)collection
                                         results:(PHFetchResult * _Nonnull)results;

@property (nonatomic, strong, nullable) NSDate *startDate;

@property (nonatomic, copy, nullable) NSString *identifier;

/*
 @note use this model to store the album's 'result, 'count, 'name, 'startDate
 to avoid request and reserve too much times.
 */
@property (nonatomic, strong, nullable) PHFetchResult *results;

#endif

@property (nonatomic, copy, nonnull) NSString *albumTitle;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, readonly, nonnull) NSAttributedString *albumAttributedString;

- (void)fetchPostImageWithSize:(CGSize)size imageResutHandler:(void (^ _Nullable)(UIImage * _Nullable))handler;

@end


NS_ASSUME_NONNULL_END