//
//  GalleryCollectionViewCell.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "GalleryCollectionViewCell.h"
#import "StorageManager.h"
#import "Photo.h"
#import "Filter.h"

@interface GalleryCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *filterImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@end

@implementation GalleryCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPhoto:(Photo *)photo {
    self.filterImageView.image = [UIImage imageWithContentsOfFile:[[StorageManager instance] absoluteFilePath:photo.thumbnailPath]];
    
    NSString *string = [Filter nameForFilter:photo.filter effect:photo.effect];
    
    NSRange heartRange = [string rangeOfString:@"♥"];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:.392156863 green:.392156863 blue:.392156863 alpha:1.0] range:NSMakeRange(0, string.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:9] range:NSMakeRange(0, string.length)];
    
    if (heartRange.length > 0) {
        [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HiraKakuProN-W6" size:9] range:heartRange];
    }
    
    self.titleLabel.attributedText = attrString;
    self.titleLabel.textAlignment = 1;
    self.filterImageView.layer.cornerRadius = 4;
    self.filterImageView.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
