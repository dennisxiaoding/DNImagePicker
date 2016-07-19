//
//  DNImagePickerManager.m
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNImagePickerManager.h"
#import "DNImagePicker.h"
#import "DNAlbum.h"

static NSString* const kDNImagePickerStoredGroupKey = @"com.dennis.kDNImagePickerStoredGroup";

@implementation DNImagePickerManager

- (DNAlbumAuthorizationStatus)authorizationStatus {
#if DNImagePikerPhotosAvaiable == 1
    return (DNAlbumAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
#else
    return (DNAlbumAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
#endif
}

#if DNImagePikerPhotosAvaiable == 1
- (NSArray *)fetchAlbumList {
    NSMutableArray *albums = [NSMutableArray arrayWithArray:[self fetchAlbumList]];
    if (!albums)
        return [NSArray array];
    
    PHFetchOptions *userAlbumsOptions = [[PHFetchOptions alloc] init];
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType",@(PHAssetMediaTypeImage)];
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
                    DNAlbum *album = [[DNAlbum alloc] init];
                    album.count = count;
                    album.results = assetResults;
                    album.name = obj.localizedTitle;
                    album.startDate = obj.startDate;
                    album.identifier = obj.localIdentifier;
                    [list addObject:album];
                }
            }
        }];
    }
    return list;
}

- (DNAlbum *)fetchCurrentAlbum {
    DNAlbum *album = [[DNAlbum alloc] init];
    NSString *identifier = [self albumIdentifier];
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
    album.name = collection.localizedTitle;
    album.results = requestReslut;
    album.count = requestReslut.count;
    album.startDate = collection.startDate;
    album.identifier = collection.localIdentifier;
    return album;
}

- (NSArray *)fetchAlbumsResults {
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
#endif


- (void)saveAblumIdentifier:(NSString *)identifier {
    if (identifier.length <= 0)  return;
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:kDNImagePickerStoredGroupKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)albumIdentifier {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDNImagePickerStoredGroupKey];
}


@end
