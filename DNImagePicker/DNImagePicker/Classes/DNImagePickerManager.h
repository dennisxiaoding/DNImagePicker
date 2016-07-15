//
//  DNImagePickerManager.h
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNImagePicker.h"

@interface DNImagePickerManager : NSObject

/**
 *  Returns information about your app’s authorization for accessing the user’s Photos library.
    The current authorization status. See `DNAlbumAuthorizationStatus`.
 *
 *  @return The current authorization status.
 */
- (DNAlbumAuthorizationStatus)authorizationStatus;


- (NSArray *)fetchAlbumList;


// storeage
- (void)saveAblumIdentifier:(NSString *)identifier;

- (NSString *)albumIdentifier;

@end
