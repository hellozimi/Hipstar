//
//  Filter.h
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FilterGenerator.h"
#import "GPUImage.h"

@interface Filter : NSObject <NSCoding>

+ (Filter *)filter;

+ (NSString *)nameForFilter:(Filter *)filter effect:(Filter *)effect;

- (UIImage *)apply:(UIImage *)image;
- (UIImage *)imageByApplyingAlpha:(UIImage *)image alpha:(CGFloat) alpha;

- (UIImage *)applyLookup:(NSString *)lookupName image:(UIImage *)image;
- (UIImage *)imageName:(NSString *)imageName alpha:(float)alpha;

- (UIImage *)imageWithAlphaBlendingBottom:(UIImage *)bottomImage top:(UIImage *)topImage alpha:(float)alpha;
- (UIImage *)imageWithOverlayBlendingBottom:(UIImage *)bottomImage top:(UIImage *)topImage;

@property (nonatomic, weak, readonly) NSString *name;
@property (nonatomic, weak, readonly) UIImage *image;

@end
