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

FOUNDATION_EXTERN NSString * const DNImagePickerPhotoLibraryChangedNotification;

NS_ASSUME_NONNULL_BEGIN

@interface DNImagePickerHelper : NSObject

+ (instancetype)sharedHelper;

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
+ (void)requestAlbumListWithCompleteHandler:(void(^)(NSArray<DNAlbum *>* anblumList))competeHandler;

/**
 *  Fetch the album which is stored by identifier; if not stored, it'll return the album without anything.
 *
 *  @return the stored album
 */
+ (void)requestCurrentAblumWithCompleteHandler:(void(^)(DNAlbum * album))completeHandler;


/**
 fetch images in the specific ablum
 
 @param album target album
 @param completeHandler callbacks with imageArray
 */
+ (void)fetchImageAssetsInAlbum:(DNAlbum *)album completeHandler:(void(^)(NSArray<DNAsset *>* imageArray))completeHandler;


+ (void)fetchImageSizeWithAsset:(PHAsset *)asset
         imageSizeResultHandler:(void (^)(CGFloat imageSize, NSString * sizeString))handler NS_AVAILABLE_IOS(8_0);


/**
 fetch Image with assets
 
 @param asset target assets
 @param targetSize target size
 @param isHighQuality is need highQuality
 @param handler callback with image
 */
+ (void)fetchImageWithAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize
            needHighQuality:(BOOL)isHighQuality
          imageResutHandler:(void (^)(UIImage * image))handler NS_AVAILABLE_IOS(8_0);
/**
 fetch Image with assets
 same as `fetchImageWithAsset:targetSize:needHighQuality:imageResutHandler:` param `isHighQuality` is NO
 */
+ (void)fetchImageWithAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize
          imageResutHandler:(void (^)(UIImage *))handler NS_AVAILABLE_IOS(8_0);

// storeage
+ (void)saveAblumIdentifier:(NSString *)identifier;

+ (NSString *)albumIdentifier;


@end
NS_ASSUME_NONNULL_END
