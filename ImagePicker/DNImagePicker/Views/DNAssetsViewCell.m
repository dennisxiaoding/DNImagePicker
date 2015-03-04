//
//  DNAssetsViewCell.m
//  ImagePicker
//
//  Created by DingXiao on 15/2/11.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import "DNAssetsViewCell.h"


@interface DNAssetsViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@property (nonatomic, weak) IBOutlet UIImageView *checkImageView;

- (IBAction)checkButtonAction:(id)sender;

@end

@implementation DNAssetsViewCell
- (void)fillWithAsset:(ALAsset *)asset isSelected:(BOOL)seleted
{
    self.isSelected = seleted;
    self.asset = asset;
    CGImageRef thumbnailImageRef = [asset thumbnail];
    if (thumbnailImageRef) {
        self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
    } else {
        self.imageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    self.checkButton.selected = _isSelected;
    [self updateCheckImageView];
}

- (void)updateCheckImageView
{
    if (self.checkButton.selected) {
        self.checkImageView.image = [UIImage imageNamed:@"photo_check_selected"];
    }else
    {
        self.checkImageView.image = [UIImage imageNamed:@"photo_check_default"];
    }
}

- (void)checkButtonAction:(id)sender
{
    if (self.checkButton.selected) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDeselectItemAssetsViewCell:)]) {
            [self.delegate didDeselectItemAssetsViewCell:self];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAssetsViewCell:)]) {
            [self.delegate didSelectItemAssetsViewCell:self];
        }
    }
}

- (void)prepareForReuse
{
    _asset = nil;
    _isSelected = NO;
    _delegate = nil;
    _imageView.image = nil;
}

@end
