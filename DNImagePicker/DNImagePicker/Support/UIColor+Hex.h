//
//  UIColor+Hex.h
//  imoffice
//
//  Created by zhanghao on 14-9-11.
//  Copyright (c) 2014年 IMO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor;

@end
