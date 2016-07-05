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

#endif /* DNImagePicker_h */
