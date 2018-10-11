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

#define kSizeThumbnailCollectionView ceil(self.view.frame.size.width/2)

@interface CollectionViewController ()
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"seletedImageTitle", @"seletedImage");
    self.collectionView.alwaysBounceVertical = YES;
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    DNAsset *dnasset = self.imageArray[indexPath.row];
    [dnasset fetchImageWithSize:CGSizeMake(kSizeThumbnailCollectionView-4, kSizeThumbnailCollectionView*1.5) imageResutHandler:^(UIImage * _Nullable image) {
        cell.imageView.image = image;
    }];
    [dnasset fetchImageSizeWithHandler:^(CGFloat imageSize, NSString * _Nonnull sizeString) {
         cell.textLabel.text = sizeString;
    }];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kSizeThumbnailCollectionView-8, kSizeThumbnailCollectionView*1.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}



@end
