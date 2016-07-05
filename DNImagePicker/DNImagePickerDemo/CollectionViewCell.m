//
//  CollectionViewCell.m
//  ImagePicker
//
//  Created by DingXiao on 15/3/6.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib
{
    self.textLabel.backgroundColor = [UIColor colorWithRed:0 green:162.0f/255.0f blue:255.0f/255.0f alpha:0.5];
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
    self.textLabel.text = nil;
}


@end
