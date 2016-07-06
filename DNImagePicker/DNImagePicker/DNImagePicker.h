//
//  DNImagePicker.h
//  ImagePicker
//
//  Created by Ding Xiao on 16/7/5.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#ifndef DNImagePicker_h
#define DNImagePicker_h

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000)
    #import <Photos/Photos.h>
    #ifndef DNImagePikerPhotosAvaiable
    #define DNImagePikerPhotosAvaiable 1
    #endif
#else
    #import <AssetsLibrary/AssetsLibrary.h>
    #ifndef DNImagePikerPhotosAvaiable
    #define DNImagePikerPhotosAvaiable 0
    #endif
#endif



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

#endif /* DNImagePicker_h */
