//
//  DNImagePicker.h
//  ImagePicker
//
//  Created by Ding Xiao on 16/7/1.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#ifndef DNImagePicker_h
#define DNImagePicker_h

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 80000)
    #import <Photos/Photos.h>
#else
    #import <AssetsLibrary/AssetsLibrary.h>
#endif

#endif /* DNImagePicker_h */
