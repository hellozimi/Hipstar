//
//  ShareViewController.h
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo, Filter;

@interface ShareViewController : UIViewController

@property (nonatomic, strong) UIImage *previewImage;
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic, strong) Filter *filter;
@property (nonatomic, strong) Filter *effect;

@property (nonatomic, strong) Photo *photo;

@end
