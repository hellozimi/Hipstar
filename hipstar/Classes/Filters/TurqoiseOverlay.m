//
//  TurqoiseOverlay.m
//  hipstar
//
//  Created by Simon Andersson on 11/10/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "TurqoiseOverlay.h"
#import "RedOverlay.h"

@implementation TurqoiseOverlay

- (void)apply:(CGContextRef)bitmapContext {
    
    
    CGContextRef circleContext = BitmapContextCreateCopy(bitmapContext);
    
    CGContextSetAlpha(bitmapContext, 0.29);
    CGContextSetBlendMode(bitmapContext, kCGBlendModeLighten);
    
    size_t width = CGBitmapContextGetWidth(bitmapContext);
    size_t height = CGBitmapContextGetHeight(bitmapContext);
    
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGContextSetFillColorWithColor(bitmapContext, [UIColor colorWithHue:0.439 saturation:0.830 brightness:0.992 alpha:1].CGColor);
    
    CGContextFillRect(bitmapContext, rect);
    
    
    BitmapContextCompositeImageNamed(bitmapContext, @"fx-film-filmgrain.jpg", 0.4, kCGBlendModeScreen);
    
    CGImageRef image = CGBitmapContextCreateImage(circleContext);
    CGContextRef ctx = BitmapContextCreateWithSize(CGSizeMake(width, height));
    
    CGContextAddEllipseInRect(ctx, CGRectInset(rect, width*0.1, height*0.1));
    CGContextClip(ctx);
    
    CGContextTranslateCTM(ctx, 0, rect.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextDrawImage(ctx, rect, image);
    
    CGImageRelease(image);
    
    [[RedOverlay filter] apply:ctx];
    
    BitmapContextComposite(bitmapContext, ctx, 1.0, kCGBlendModeNormal);
    BitmapContextRelease(circleContext);
    CGContextRelease(circleContext);
    CGContextRelease(ctx);
}

@end
