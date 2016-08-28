//
//  DNAlbumCell.m
//  DNImagePicker
//
//  Created by DingXiao on 16/8/29.
//  Copyright © 2016年 Dennis. All rights reserved.
//

#import "DNAlbumCell.h"

@implementation DNAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)addContentConstraints {
    // TODO: add Constraints
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIImageView *)postImageView {
    if (!_postImageView) {
        _postImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_postImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_postImageView];
    }
    return _postImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
