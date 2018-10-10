//
//  DNImagePickerHelper.h
//  DNImagePicker
//
//  Created by Ding Xiao on 16/8/23.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNImagePicker.h"

@class DNAlbum;
@class DNAsset;
NS_ASSUME_NONNULL_BEGIN

@interface DNImagePickerHelper : NSObject

+ (nonnull instancetype)sharedHelper;

+ (void)cancelFetchWithAssets:(PHAsset *)asset NS_AVAILABLE_IOS(8_0);

/**
 *  Returns information about your app’s authorization for accessing the user’s Photos library.
 The current authorization status. See `DNAlbumAuthorizationStatus`.
 *
 *  @return The current authorization status.
 */
+ (DNAlbumAuthorizationStatus)authorizationStatus;

/**
 *  Fetch the albumlist
 *
 */
+ (void)requestAlbumListWithCompleteHandler:(void(^)(NSArray<DNAlbum *>* _Nullable anblumList))competeHandler;

/**
 *  Fetch the album which is stored by identifier; if not stored, it'll return the album without anything.
 *
 *  @return the stored album
 */
+ (nonnull DNAlbum *)fetchCurrentAlbum;

/**
 *  fetch `PHAsset` array via CollectionResults
 *
 *  @param results collection fetch results
 *
 *  @return `PHAsset` array in collection
 */
+ (nonnull NSArray *)fetchImageAssetsViaCollectionResults:(nullable PHFetchResult *)results NS_AVAILABLE_IOS(8_0);

/**
 *  fetch `PHAsset` array via CollectionResults
 *
 *  @param results collection fetch results
 *  @param option  NSEnumerationOptions
 *
 *  @return `PHAsset` array in collection
 */
+ (nonnull NSArray *)fetchImageAssetsViaCollectionResults:(nullable PHFetchResult *)results
                                       enumerationOptions:(NSEnumerationOptions)option NS_AVAILABLE_IOS(8_0);


+ (void)fetchImageSizeWithAsset:(nullable PHAsset *)asset
         imageSizeResultHandler:(void ( ^ _Nonnull)(CGFloat imageSize,  NSString * _Nonnull sizeString))handler NS_AVAILABLE_IOS(8_0);

+ (void)fetchImageWithAsset:(nullable PHAsset *)asset
                             targetSize:(CGSize)targetSize
                        needHighQuality:(BOOL)isHighQuality
                      imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler NS_AVAILABLE_IOS(8_0);

+ (void)fetchImageWithAsset:(nullable PHAsset *)asset
                             targetSize:(CGSize)targetSize
                      imageResutHandler:(void (^ _Nullable)(UIImage * _Nullable))handler NS_AVAILABLE_IOS(8_0);

// storeage
+ (void)saveAblumIdentifier:(nullable NSString *)identifier;

+ (nullable NSString *)albumIdentifier;


@end
NS_ASSUME_NONNULL_END
