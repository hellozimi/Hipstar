//
//  Loader.m
//  hipstar
//
//  Created by Simon Andersson on 11/13/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Loader.h"

@interface Loader ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation Loader

+ (Loader *)loader {
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        self.contentView.layer.cornerRadius = 4;
        
        [self addSubview:self.contentView];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityIndicator.frame = self.contentView.bounds;
        
        [self.contentView addSubview:self.activityIndicator];
        [self.activityIndicator startAnimating];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.origin = CGPointMake((self.window.width-self.contentView.width)/2, (self.window.height-self.contentView.height)/2);
}

- (void)show {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = UIWindowLevelAlert;
    [self layoutSubviews];
    
    [self.window addSubview:self];
    
    [self.window makeKeyAndVisible];
    
    self.alpha = 0;
    
    self.origin = CGPointMake(self.origin.x, self.origin.y - 10);
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.alpha = 1.0;
        self.origin = CGPointMake(self.origin.x, self.origin.y + 10);
    } completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (void)hide {
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.alpha = 0.0;
        self.origin = CGPointMake(self.origin.x, self.origin.y + 20);
    } completion:^(BOOL finished) {
        self.window.hidden = YES;
        self.window = nil;
    }];
}

@end
