//
//  DNAlbum.h
//  DNImagePicker
//
//  Created by Ding Xiao on 16/7/6.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNImagePicker.h"

@interface DNAlbum : NSObject

#if DNImagePikerPhotosAvaiable == 1
/*
 @note use this model to store the album's 'result, 'count, 'name, 'startDate
 to avoid request and reserve too much times.
 */
@property (nonatomic, strong) PHFetchResult *results;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *startDate;
#endif

@property (nonatomic, copy) NSString *identifier;

@end
