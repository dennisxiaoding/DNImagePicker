//
//  DNAlbum.m
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNAlbum.h"

@interface DNAlbum ()

@end

@implementation DNAlbum

#if DNImagePikerPhotosAvaiable == 1

+ (DNAlbum *)albumWithAssetCollection:(PHAssetCollection *)collection results:(PHFetchResult *)results{
    DNAlbum *album = [[DNAlbum alloc] init];
    album.albumTitle = @"";
    album.count = results.count;
    album.results = results;
    album.albumTitle = collection.localizedTitle;
    album.startDate = collection.startDate;
    album.identifier = collection.localIdentifier;
    return album;
}

#endif

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
