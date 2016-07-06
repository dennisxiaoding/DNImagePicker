//
//  DNImagePickerManager.m
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNImagePickerManager.h"
#import "DNImagePicker.h"

static NSString* const kDNImagePickerStoredGroupKey = @"com.dennis.kDNImagePickerStoredGroup";

@implementation DNImagePickerManager

- (DNAlbumAuthorizationStatus)authorizationStatus {
#if DNImagePikerPhotosAvaiable == 1
    return (DNAlbumAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
#else
    return (DNAlbumAuthorizationStatus)[ALAssetsLibrary authorizationStatus];
#endif
}

- (void)saveAblumIdentifier:(NSString *)identifier {
    if (identifier.length <= 0)  return;
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:kDNImagePickerStoredGroupKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)albumIdentifier {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDNImagePickerStoredGroupKey];
}


@end
