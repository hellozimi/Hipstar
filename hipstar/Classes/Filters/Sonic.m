//
//  Sonic.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Sonic.h"

@implementation Sonic

- (UIImage *)apply:(UIImage *)image {
    
    UIImage *sonicOverlay = [UIImage imageNamed:@"sonic_overlay"];
    
    
    CGContextRef context = BitmapContextCreateWithImage(image, image.size);
    float scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
    
    
    CGContextDrawImage(context, rect, image.CGImage);
    
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeScreen);
    CGContextSetAlpha(context, 0.5);
    CGContextDrawImage(context, rect, sonicOverlay.CGImage);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGContextSetAlpha(context, 0.5);
    CGContextDrawImage(context, rect, sonicOverlay.CGImage);
    CGContextRestoreGState(context);
    
    image = BitmapImageCreateFromContext(context);
    
    CGContextRelease(context);
    
    return image;
}

- (NSString *)name {
    return @"Sonic";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Sonic"];
}

@end
