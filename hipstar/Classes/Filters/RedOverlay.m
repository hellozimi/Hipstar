//
//  RedOverlay.m
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "RedOverlay.h"
#import "FilterGenerator.h"

@implementation RedOverlay

- (void)apply:(CGContextRef)bitmapContext {
    
    CGContextSetAlpha(bitmapContext, 0.5);
    CGContextSetBlendMode(bitmapContext, kCGBlendModeScreen);
    
    size_t width = CGBitmapContextGetWidth(bitmapContext);
    size_t height = CGBitmapContextGetHeight(bitmapContext);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGContextSetFillColorWithColor(bitmapContext, [UIColor redColor].CGColor);
    
    CGContextFillRect(bitmapContext, rect);
}

@end
