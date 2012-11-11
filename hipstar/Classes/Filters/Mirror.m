//
//  Mirror.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Mirror.h"

@implementation Mirror

- (UIImage *)apply:(UIImage *)image {
    
    
    CGContextRef context = BitmapContextCreateWithImage(image, image.size);
    float scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
    
    float offset = rect.size.width * 0.1;
    
    CGContextAddEllipseInRect(context, CGRectInset(rect, offset, offset));
    
    CGContextClip(context);
    
    CGContextTranslateCTM(context, rect.size.width, 0);
    CGContextScaleCTM(context, -1, 1);
    CGContextDrawImage(context, rect, image.CGImage);
    
        
    CGImageRef img = CGBitmapContextCreateImage(context);
    
    image = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    
    CGContextRelease(context);
    
    return image;
}

- (NSString *)name {
    return @"Mirror";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Mirron"];
}

@end
