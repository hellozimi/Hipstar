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

@interface Filter : NSObject

+ (Filter *)filter;

- (UIImage *)apply:(UIImage *)image;
- (UIImage *)imageByApplyingAlpha:(UIImage *)image alpha:(CGFloat) alpha;

@property (nonatomic, weak, readonly) NSString *name;

@end
