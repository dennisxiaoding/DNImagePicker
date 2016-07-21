//
//  DNImagePickerManager.h
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNImagePicker.h"
@class DNAlbum;

@interface DNImagePickerManager : NSObject

/**
 *  Returns information about your app’s authorization for accessing the user’s Photos library.
    The current authorization status. See `DNAlbumAuthorizationStatus`.
 *
 *  @return The current authorization status.
 */
- (DNAlbumAuthorizationStatus)authorizationStatus;


- (nonnull NSArray *)fetchAlbumList;

/**
 *  Fetch the album which is stored by identifier; if not stored, it'll return the album without anything.
 *
 *  @return the stored album
 */
- (nonnull DNAlbum *)fetchCurrentAlbum;

/**
 *  fetch `PHAsset` array via CollectionResults
 *
 *  @param results collection fetch results
 *
 *  @return `PHAsset` array in collection
 */
- (nonnull NSArray *)fetchImageAssetsViaCollectionResults:(nullable PHFetchResult *)results;


// storeage
- (void)saveAblumIdentifier:(nullable NSString *)identifier;

- (nullable NSString *)albumIdentifier;

@end
