//
//  Target.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Target.h"

@implementation Target

- (UIImage *)apply:(UIImage *)image {
    
    CGContextRef context = BitmapContextCreateWithImage(image, image.size);
    float scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
    
    float offset = rect.size.width * 0.1;
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextAddEllipseInRect(context, CGRectInset(rect, offset, offset));
    
    CGContextClip(context);
    
    CGContextDrawImage(context, rect, image.CGImage);
    
    
    CGImageRef img = CGBitmapContextCreateImage(context);
    
    image = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    
    CGContextRelease(context);
    
    return image;
}

- (NSString *)name {
    return @"Target";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Target"];
}

@end
