//
//  DNImagePickerHelper.m
//  DNImagePicker
//
//  Created by Ding Xiao on 16/8/23.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNImagePickerHelper.h"
#import "DNImageFetchOperation.h"
#import "DNAlbum.h"
#import "DNAsset.h"

static NSString* const kDNImagePickerStoredGroupKey = @"com.dennis.kDNImagePickerStoredGroup";

static dispatch_queue_t imageFetchQueue() {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.awesomedennis.dnimageFetchQueue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

static ALAssetsLibrary* assetsLibrary() {
    static ALAssetsLibrary *lib = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lib = [ALAssetsLibrary new];
    });
    return lib;
}

@interface DNImagePickerHelper ()

@property (nonatomic, strong) NSOperationQueue *imageFetchQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, DNImageFetchOperation*> *fetchImageOperationDics;

@end

@implementation DNImagePickerHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _imageFetchQueue = [NSOperationQueue new];
        _imageFetchQueue.maxConcurrentOperationCount = 8;
        _imageFetchQueue.name = @"com.awesomedennis.dnnimagefetchQueue";
        _fetchImageOperationDics = [NSMutableDictionary dictionaryWithCapacity:50];
    }
    return self;
}

+ (dispatch_semaphore_t)imageFetchSemaphore {
    static dispatch_semaphore_t _imageFetchSemaphore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _imageFetchSemaphore = dispatch_semaphore_create(9);
    });
    return _imageFetchSemaphore;
}

#pragma mark -
#pragma mark - public

+ (DNAlbumAuthorizationStatus)authorizationStatus {
    if (@available(iOS 8.0, *)) {
        return (DNAlbumAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
    } else {
        return (DNAlbumAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
    }
}

+ (void)requestAlbumListWithCompleteHandler:(void (^)(NSArray<DNAlbum *> *))competeHandler {
    if (@available(iOS 8.0, *)) {
        [self fetchAlbumListInPhotosWithCompleteHandelr:competeHandler];
    } else {
        [self _fetchAlbumListInAssetsLibraryWithCompleteHandler:competeHandler];
    }
}

+ (DNAlbum *)fetchCurrentAlbum {
    DNAlbum *album = [[DNAlbum alloc] init];
    NSString *identifier = [DNImagePickerHelper albumIdentifier];
    if (!identifier || identifier.length <= 0) {
        return album;
    }
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifier] options:nil];
    
    if (result.count <= 0) {
        return album;
    }
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %@",@(PHAssetMediaTypeImage)];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetCollection *collection = result.firstObject;
    
    PHFetchResult *requestReslut = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    album.albumTitle = collection.localizedTitle;
    album.results = requestReslut;
    album.count = requestReslut.count;
    album.startDate = collection.startDate;
    album.identifier = collection.localIdentifier;
    return album;
}


+ (void)fetchImageAssetsInAlbum:(DNAlbum *)album completeHandler:(void (^)(NSArray<DNAsset *> *))completeHandler {
    if (@available(iOS 8.0, *)) {
        [self _PHfetchImageAssetsInAlbum:album completeHandler:completeHandler];
    } else {
        [self _ALfetchImageAssetsInAlbum:album completeHandler:completeHandler];
    }
}

+ (void)fetchImageSizeWithAsset:(PHAsset *)asset
         imageSizeResultHandler:(void (^)(CGFloat imageSize, NSString * sizeString))handler {
    if (!asset) {
        handler(0,@"0M");
        return;
    }
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:nil
                                                resultHandler:^(NSData *imageData,
                                                                NSString *dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary *info) {
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


+ (void)fetchImageWithAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize
          imageResutHandler:(void (^)(UIImage *))handler {
    return  [self fetchImageWithAsset:asset targetSize:targetSize needHighQuality:NO imageResutHandler:handler];
}

+ (void)fetchImageWithAsset:(PHAsset *)asset
                 targetSize:(CGSize)targetSize
            needHighQuality:(BOOL)isHighQuality
          imageResutHandler:(void (^)(UIImage *image))handler {
    if (!asset) {
        return;
    }
    
    DNImagePickerHelper *helper = [DNImagePickerHelper sharedHelper];
    DNImageFetchOperation *operation = [[DNImageFetchOperation alloc] initWithAsset:asset];
    __weak typeof(helper) whelper = helper;
    [operation fetchImageWithTargetSize:targetSize needHighQuality:isHighQuality imageResutHandler:^(UIImage * _Nonnull image) {
        __strong typeof(whelper) shelper = whelper;
        [shelper.fetchImageOperationDics removeObjectForKey:asset.localIdentifier];
        handler(image);
    }];
    [helper.imageFetchQueue addOperation:operation];
    [helper.fetchImageOperationDics setObject:operation forKey:asset.localIdentifier];
}

+ (void)cancelFetchWithAssets:(PHAsset *)asset {
    if (!asset) {
        return;
    }
    DNImagePickerHelper *helper = [DNImagePickerHelper sharedHelper];
    DNImageFetchOperation *operation = [helper.fetchImageOperationDics objectForKey:asset.localIdentifier];
    if (operation) {
        [operation cancel];
    }
    [helper.fetchImageOperationDics removeObjectForKey:asset.localIdentifier];
}

#pragma mark -
#pragma mark - priviate Photos

+ (void)_PHfetchImageAssetsInAlbum:(DNAlbum *)album completeHandler:(void (^)(NSArray<DNAsset *> *))completeHandler {
    dispatch_async(imageFetchQueue(), ^{
        NSArray<DNAsset *> *array = [self fetchImageAssetsViaCollectionResults:album.results];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeHandler) {
                completeHandler(array);
            }
        });
    });
}

/**
 *  fetch `PHAsset` array via CollectionResults
 *
 *  @param results collection fetch results
 *
 *  @return `DNAsset` array in collection
 */
+ (NSArray *)fetchImageAssetsViaCollectionResults:(PHFetchResult *)results {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:results.count];
    if (!results) {
        return array;
    }
    
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            DNAsset *asset = [DNAsset assetWithPHAsset:obj];
            [array addObject:asset];
        }
    }];
    
    return [[array reverseObjectEnumerator] allObjects];
}

+ (void)fetchAlbumListInPhotosWithCompleteHandelr:(void(^)(NSArray<DNAlbum*> *albumList))completeHandelr {
    
    dispatch_block_t block = ^{
        NSMutableArray *albums = [NSMutableArray arrayWithArray:[self fetchAlbumsResults]];
        if (!albums) {
            completeHandelr(nil);
            return;
        }
        
        PHFetchOptions *userAlbumsOptions = [[PHFetchOptions alloc] init];
        userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %@",@(PHAssetMediaTypeImage)];
        userAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
        
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
                        [list addObject:album];
                    }
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeHandelr) {
                completeHandelr([list copy]);
            }
        });
    };
    dispatch_async(imageFetchQueue(), block);
}

+ (NSArray *)fetchAlbumsResults {
    PHFetchOptions *userAlbumsOptions = [[PHFetchOptions alloc] init];
    userAlbumsOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    userAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:YES]];
    
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

#pragma mark -
#pragma mark - priviate AssetsLibrary

+ (void)_ALfetchImageAssetsInAlbum:(DNAlbum *)album completeHandler:(void (^)(NSArray<DNAsset *> * _Nonnull))completeHandler {
    dispatch_async(imageFetchQueue(), ^{
        NSMutableArray *a = [NSMutableArray array];
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        [assetsLibrary() groupForURL:[NSURL URLWithString:album.identifier] resultBlock:^(ALAssetsGroup *group) {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result) {
                    [a addObject:[DNAsset assetWithALAsset:result]];
                }
                if (!result || *stop) {
                    dispatch_semaphore_signal(sem);
                }
            }];
        } failureBlock:^(NSError *error) {
            dispatch_semaphore_signal(sem);
        }];
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeHandler) {
                completeHandler([[a reverseObjectEnumerator] allObjects]);
            }
        });
    });
}

+ (NSArray *)_assetsArrayFromAssetsGroupType:(ALAssetsGroupType)type {
    NSMutableArray *albumArray = [NSMutableArray array];
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    [assetsLibrary() enumerateGroupsWithTypes:type
                                   usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                       if (assetsGroup) {
                                           // Filter the assets group
                                           [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                                           // Add assets group
                                           if (assetsGroup.numberOfAssets > 0) {
                                               // Add assets group
                                               DNAlbum *album = [DNAlbum albumWithAssetGroup:assetsGroup];
                                               [albumArray addObject:album];
                                           }
                                       }
                                       if (*stop || !assetsGroup) {
                                           dispatch_semaphore_signal(sem);
                                       }
                                   } failureBlock:^(NSError *error) {
                                       dispatch_semaphore_signal(sem);
                                   }];
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return [albumArray copy];
}

+ (void)_fetchAlbumListInAssetsLibraryWithCompleteHandler:(void(^)(NSArray<DNAlbum*> *albumList))completeHandelr {
    dispatch_async(imageFetchQueue(), ^{
        NSMutableArray *albumArray = [NSMutableArray array];
        
        NSArray *all = [self _assetsArrayFromAssetsGroupType:ALAssetsGroupAll];
        if (all && all.count) {
            [albumArray addObjectsFromArray:all];
        }
        
        if (albumArray.count > 0) {
            NSArray *sortedAssetsGroups = [albumArray
                                           sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

                                               DNAlbum *a = obj1;
                                               DNAlbum *b = obj2;
                                               
                                               NSNumber *apropertyType = @(a.albumPropertyType.doubleValue);
                                               NSNumber *bpropertyType = @(b.albumPropertyType.doubleValue);
                                               if ([apropertyType compare:bpropertyType] == NSOrderedAscending)
                                               {
                                                   return NSOrderedDescending;
                                               }
                                               return NSOrderedSame;
                                           }];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeHandelr) {
                    completeHandelr(sortedAssetsGroups);
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeHandelr) {
                    completeHandelr([albumArray copy]);
                }
            });
        }
    });
}

+ (void)saveAblumIdentifier:(NSString *)identifier {
    if (identifier.length <= 0)  return;
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:kDNImagePickerStoredGroupKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)albumIdentifier {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDNImagePickerStoredGroupKey];
}


@end
