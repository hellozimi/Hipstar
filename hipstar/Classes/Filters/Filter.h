//
//  Filter.h
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FilterGenerator.h"

@interface Filter : NSObject

+ (Filter *)filter;
- (void)apply:(CGContextRef)bitmapContext;

@end
