//
//  CollectionViewController.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"

@interface CollectionViewController ()
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"seletedImageTitle", @"seletedImage");
    self.collectionView.alwaysBounceVertical = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    DNAsset *dnasset = self.imageArray[indexPath.row];
    
    ALAssetsLibrary *lib = [ALAssetsLibrary new];
    __block CollectionViewCell *blockCell = cell;
    __weak typeof(self) weakSelf = self;
    [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){

#warning ⚠️：用法强化
        //  KTJ:    URL无法使用时候请使用源数据进行获取。《iOS8.3-iPhone6x会出现无法获取URL
        asset = asset?:dnasset.alAsset;
        //不保证此方法下面都是OK的，只是在使用DNAsset的时候请保证这个判断存在。除非你适配iOS8.3-iPhone6x机型。
        
        // iOS8.3-iPhone6x机型会走这个方法，但是asset为空。。。。所以作出如上优化。
        
        
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (asset) {
            [strongSelf setCell:blockCell asset:asset];
        } else {
            // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
            [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
             {
                 [group enumerateAssetsWithOptions:NSEnumerationReverse
                                        usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                     
                     if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:dnasset.url])
                     {
                         [strongSelf setCell:blockCell asset:result];
                         *stop = YES;
                     }
                 }];
             }
                             failureBlock:^(NSError *error)
             {
                 [strongSelf setCell:blockCell asset:nil];
             }];
        }
        
    } failureBlock:^(NSError *error){
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf setCell:blockCell asset:nil];
    }];
    
    
    return cell;
}

- (void)setCell:(CollectionViewCell *)cell asset:(ALAsset *)asset
{
    
    if (!asset) {
        cell.imageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
        cell.textLabel.hidden = YES;
        return;
    }
    
    cell.textLabel.hidden = NO;
    UIImage *image;
    NSString *string;
    if (self.isFullImage) {
        NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
        UIImageOrientation orientation = UIImageOrientationUp;
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        
        image = [UIImage imageWithCGImage:asset.thumbnail];
//        image = [UIImage imageWithCGImage:asset.thumbnail scale:0.1 orientation:orientation];
        
        string = [NSString stringWithFormat:@"fileSize:%lld k\nwidth:%.0f\nheiht:%.0f",asset.defaultRepresentation.size/1000,[[asset defaultRepresentation] dimensions].width, [[asset defaultRepresentation] dimensions].height];
        
    } else {
        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        string = [NSString stringWithFormat:@"fileSize:%lld k\nwidth:%.0f\nheiht:%.0f",asset.defaultRepresentation.size/1000,image.size.width,image.size.height];
    }
   
    cell.textLabel.text = string;
    cell.imageView.image = image;

}

#define kSizeThumbnailCollectionView  self.view.frame.size.width/2

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView-4, kSizeThumbnailCollectionView*1.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}



@end
