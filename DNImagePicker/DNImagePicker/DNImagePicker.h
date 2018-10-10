//
//  DNImagePicker.h
//  ImagePicker
//
//  Created by Ding Xiao on 16/7/5.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSUInteger, DNAlbumAuthorizationStatus) {
    // User has not yet made a choice with regards to this application
    DNAlbumAuthorizationStatusNotDetermined = 0,
    // This application is not authorized to access photo data.
    // The user cannot change this application’s status, possibly due to active restrictions
    // such as parental controls being in place.
    DNAlbumAuthorizationStatusRestricted,
    // User has explicitly denied this application access to photos data.
    DNAlbumAuthorizationStatusDenied,
    // User has authorized this application to access photos data.
    DNAlbumAuthorizationStatusAuthorized
};

typedef NS_ENUM(NSUInteger, DNImagePickerFitlerType) {
    DNImagePickerFitlerTypeUnknown = 0,
    DNImagePickerFitlerTypeImage   = 1,
    DNImagePickerFitlerTypeVideo   = 2,
    DNImagePickerFitlerTypeAudio   = 3,
};

