//
//  DNAlbum.m
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNAlbum.h"
#import "DNImagePickerHelper.h"
#import "DNAsset.h"

@interface DNAlbum ()

@end

@implementation DNAlbum


+ (DNAlbum *)albumWithAssetCollection:(PHAssetCollection *)collection results:(PHFetchResult *)results{
    DNAlbum *album = [[DNAlbum alloc] init];
    album.count = results.count;
    album.results = results;
    album.albumTitle = collection.localizedTitle;
    album.startDate = collection.startDate;
    album.identifier = collection.localIdentifier;
    return album;
}


+ (DNAlbum * _Nonnull)albumWithAssetGroup:(ALAssetsGroup *)assetGroup {
    DNAlbum *album = [[DNAlbum alloc] init];
    album.albumTitle = [assetGroup valueForProperty:ALAssetsGroupPropertyName];
    album.count = assetGroup.numberOfAssets;
    album.identifier = [assetGroup valueForProperty:ALAssetsGroupPropertyURL];
    album.albumPropertyType = [assetGroup valueForProperty:ALAssetsGroupPropertyType];
    album.posterImage = [UIImage imageWithCGImage:assetGroup.posterImage];
    return album;
}


- (void)fetchPostImageWithSize:(CGSize)size
             imageResutHandler:(void (^ _Nullable)(UIImage * _Nullable))handler {
    if (@available(iOS 8.0, *)) {
        [DNImagePickerHelper fetchImageWithAsset:self.results.firstObject
                                      targetSize:size
                               imageResutHandler:^(UIImage * _Nullable postImage) {
                                   handler(postImage);
                               }];
    } else {
        handler(self.posterImage);
    }
    
}

- (NSAttributedString *)albumAttributedString {
    NSString *numberString = [NSString stringWithFormat:@"  (%@)",@(self.count)];
    NSString *cellTitleString = [NSString stringWithFormat:@"%@%@",self.albumTitle,numberString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cellTitleString];
    [attributedString setAttributes: @{
                                       NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                       NSForegroundColorAttributeName : [UIColor blackColor],
                                       }
                              range:NSMakeRange(0, self.albumTitle.length)];
    [attributedString setAttributes:@{
                                      NSFontAttributeName : [UIFont systemFontOfSize:16.0f],
                                      NSForegroundColorAttributeName : [UIColor grayColor],
                                      } range:NSMakeRange(self.albumTitle.length, numberString.length)];
    return attributedString;
}

@end
