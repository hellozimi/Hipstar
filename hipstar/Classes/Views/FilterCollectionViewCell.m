//
//  FilterCollectionViewCell.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "FilterCollectionViewCell.h"

@interface FilterCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UIImageView *filterImageView;
@property (nonatomic, weak) IBOutlet UIImageView *filterBorderImageView;
@property (nonatomic, weak) IBOutlet UIImageView *selectedImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@end

@implementation FilterCollectionViewCell {
}

@synthesize selected = _selected;

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _selectedImageView.left = 3;
    _selectedImageView.top = 3.5;
    _selectedImageView.hidden = !self.isSelected;
    
    self.backgroundColor = [UIColor clearColor];
    
    _filterImageView.layer.cornerRadius = 3.5;
    _filterImageView.layer.masksToBounds = YES;
}

- (void)setFilterImage:(UIImage *)filterImage {
    _filterImageView.image = filterImage;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    [self layoutSubviews];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;;
}

@end
