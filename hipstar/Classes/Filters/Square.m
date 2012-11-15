//
//  Square.m
//  hipstar
//
//  Created by Simon Andersson on 11/15/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Square.h"

@implementation Square

- (UIImage *)apply:(UIImage *)image {
    CGContextRef context = BitmapContextCreateWithImage(image, image.size);
    float scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
    
    float offset = rect.size.width * 0.076;
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.11].CGColor);
    CGContextSetBlendMode(context, kCGBlendModeScreen);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.06].CGColor);
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextClipToRect(context, CGRectInset(rect, offset, offset));
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRestoreGState(context);
    image = BitmapImageCreateFromContext(context);
    
    CGContextRelease(context);
    
    return image;
}

- (NSString *)name {
    return @"Square";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Square"];
}

@end
