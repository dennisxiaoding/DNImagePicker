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

@interface DNImagePickerHelper : NSObject

/**
 *  Returns information about your app’s authorization for accessing the user’s Photos library.
 The current authorization status. See `DNAlbumAuthorizationStatus`.
 *
 *  @return The current authorization status.
 */
+ (DNAlbumAuthorizationStatus)authorizationStatus;


+ (nonnull NSArray<DNAlbum *> *)fetchAlbumList;

/**
 *  Fetch the album which is stored by identifier; if not stored, it'll return the album without anything.
 *
 *  @return the stored album
 */
+ (nonnull DNAlbum *)fetchCurrentAlbum;

#if DNImagePikerPhotosAvaiable == 1
/**
 *  fetch `PHAsset` array via CollectionResults
 *
 *  @param results collection fetch results
 *
 *  @return `PHAsset` array in collection
 */
+ (nonnull NSArray *)fetchImageAssetsViaCollectionResults:(nullable PHFetchResult *)results;

/**
 *  fetch `PHAsset` array via CollectionResults
 *
 *  @param results collection fetch results
 *  @param option  NSEnumerationOptions
 *
 *  @return `PHAsset` array in collection
 */
+ (nonnull NSArray *)fetchImageAssetsViaCollectionResults:(nullable PHFetchResult *)results
                                       enumerationOptions:(NSEnumerationOptions)option;


+ (void)fetchImageSizeWithAsset:(nullable PHAsset *)asset
         imageSizeResultHandler:(void ( ^ _Nonnull)(CGFloat imageSize,  NSString * _Nonnull sizeString))handler;

+ (PHImageRequestID)fetchImageWithAsset:(nullable PHAsset *)asset
                             targetSize:(CGSize)targetSize
                        needHighQuality:(BOOL)isHighQuality
                      imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler;

+ (PHImageRequestID)fetchImageWithAsset:(nullable PHAsset *)asset
                             targetSize:(CGSize)targetSize
                      imageResutHandler:(void (^ _Nullable)(UIImage * _Nullable))handler;

#endif

// storeage
+ (void)saveAblumIdentifier:(nullable NSString *)identifier;

+ (nullable NSString *)albumIdentifier;


@end
