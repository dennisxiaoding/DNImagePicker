//
//  DNImagePickerHelper.m
//  DNImagePicker
//
//  Created by Ding Xiao on 16/8/23.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNImagePickerHelper.h"
#import "DNAlbum.h"

static NSString* const kDNImagePickerStoredGroupKey = @"com.dennis.kDNImagePickerStoredGroup";

@implementation DNImagePickerHelper

- (DNAlbumAuthorizationStatus)authorizationStatus {
#if DNImagePikerPhotosAvaiable == 1
    return (DNAlbumAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
#else
    return (DNAlbumAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
#endif
}

#if DNImagePikerPhotosAvaiable == 1
+ (nonnull NSArray *)fetchAlbumList {
    NSMutableArray *albums = [NSMutableArray arrayWithArray:[self fetchAlbumsResults]];
    if (!albums)
        return [NSArray array];
    
    PHFetchOptions *userAlbumsOptions = [[PHFetchOptions alloc] init];
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %@",@(PHAssetMediaTypeImage)];
    userAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    NSMutableArray *list = [NSMutableArray array];
    for (PHFetchResult *result in albums) {
        [result enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PHFetchResult *assetResults = [PHAsset fetchAssetsInAssetCollection:obj options:userAlbumsOptions];
            NSInteger count = 0;
            switch (obj.assetCollectionType) {
                case PHAssetCollectionTypeAlbum:
                case PHAssetCollectionTypeSmartAlbum:
                    count = assetResults.count;
                    break;
                default:
                    count = 0;
                    break;
            }
            
            if (count > 0) {
                @autoreleasepool {
                    DNAlbum *album = [DNAlbum albumWithAssetCollection:obj results:assetResults];
                    album.count = count;
                    album.results = assetResults;
                    album.albumTitle = obj.localizedTitle;
                    album.startDate = obj.startDate;
                    album.identifier = obj.localIdentifier;
                    [list addObject:album];
                }
            }
        }];
    }
    return list;
}

+ (nonnull DNAlbum *)fetchCurrentAlbum {
    DNAlbum *album = [[DNAlbum alloc] init];
    NSString *identifier = [DNImagePickerHelper albumIdentifier];
    if (!identifier || identifier.length <= 0 ) {
        return album;
    }
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifier] options:nil];
    if (result.count <= 0) {
        return album;
    }
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType",@(PHAssetMediaTypeImage)];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetCollection *collection = result.firstObject;
    PHFetchResult *requestReslut = [PHAsset fetchKeyAssetsInAssetCollection:collection options:options];
    album.albumTitle = collection.localizedTitle;
    album.results = requestReslut;
    album.count = requestReslut.count;
    album.startDate = collection.startDate;
    album.identifier = collection.localIdentifier;
    return album;
}

+ (NSArray *)fetchAlbumsResults {
    PHFetchOptions *userAlbumsOptions = [[PHFetchOptions alloc] init];
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    userAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO]];
    NSMutableArray *albumsArray = [NSMutableArray array];
    [albumsArray addObject:
     [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                              subtype:PHAssetCollectionSubtypeAlbumRegular
                                              options:nil]];
    [albumsArray addObject:
     [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                              subtype:PHAssetCollectionSubtypeAny
                                              options:userAlbumsOptions]];
    return albumsArray;
}

- (void)fetchImageSizeWithAsset:(nullable PHAsset *)asset
         imageSizeResultHandler:(void ( ^ _Nonnull)(CGFloat imageSize,  NSString * _Nonnull sizeString))handler {
    if (!asset) {
        handler(0,@"0M");
        return;
    }
    
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:nil
                                                resultHandler:^(NSData * _Nullable imageData,
                                                                NSString * _Nullable dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary * _Nullable info) {
                                                    NSString *string = @"0M";
                                                    CGFloat imageSize = 0.0;
                                                    if (!imageData) {
                                                        handler(imageSize, string);
                                                        return;
                                                    }
                                                    imageSize = imageData.length;
                                                    if (imageSize > 1024*1024) {
                                                        CGFloat size = imageSize/(1024*2024);
                                                        string = [NSString stringWithFormat:@"%.1fM",size];
                                                    } else {
                                                        CGFloat size = imageSize/1024;
                                                        string = [NSString stringWithFormat:@"%.1fK",size];
                                                    }
                                                    handler(imageSize, string);
                                                }];
}


+ (PHImageRequestID)fetchImageWithAsset:(nullable PHAsset *)asset
                             targetSize:(CGSize)targetSize
                      imageResutHandler:(void (^ _Nullable)(UIImage * _Nullable))handler {
    return  [self fetchImageWithAsset:asset targetSize:targetSize needHighQuality:NO imageResutHandler:handler];
}

+ (PHImageRequestID)fetchImageWithAsset:(nullable PHAsset *)asset
                             targetSize:(CGSize)targetSize
                        needHighQuality:(BOOL)isHighQuality
                      imageResutHandler:(void (^ _Nullable)( UIImage * _Nullable image))handler {
    if (!asset) {
        return PHInvalidImageRequestID;
    }
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    if (isHighQuality) {
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    } else {
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
    }
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize size = CGSizeMake(targetSize.width * scale, targetSize.height * scale);
    return [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                             targetSize:size
                                                            contentMode:PHImageContentModeAspectFill
                                                                options:options
                                                          resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                              handler(result);
                                                          }];
}

#endif


+ (void)saveAblumIdentifier:(nullable NSString *)identifier {
    if (identifier.length <= 0)  return;
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:kDNImagePickerStoredGroupKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (nullable NSString *)albumIdentifier {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDNImagePickerStoredGroupKey];
}


@end
