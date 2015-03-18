//
//  UnAuthorizedTipsView.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/18.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "DNUnAuthorizedTipsView.h"

@implementation DNUnAuthorizedTipsView

- (void)awakeFromNib
{
    NSString *text = NSLocalizedStringFromTable(@"UnAuthorizedTip", @"DNImagePicker", @"UnAuthorizedTip");
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString*appName =[infoDict objectForKey:@"CFBundleDisplayName"]
    ;
    NSString *tipsString = [NSString stringWithFormat:text,appName];
    self.label.text = tipsString;
}

@end
