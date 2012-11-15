//
//  Circle.m
//  hipstar
//
//  Created by Simon Andersson on 11/15/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Circle.h"

@implementation Circle

- (UIImage *)apply:(UIImage *)image {
    
    
    CGContextRef context = BitmapContextCreateWithImage(image, image.size);
    float scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
    
    float offset = rect.size.width * 0.07;
    float inner = offset * 0.15;
    
    CGContextSaveGState(context);
    
    CGContextAddRect(context, rect);
    CGContextAddEllipseInRect(context, CGRectInset(rect, offset, offset));
    CGContextAddEllipseInRect(context, CGRectInset(rect, offset+inner, offset+inner));
    CGContextAddEllipseInRect(context, CGRectInset(rect, offset+(inner*2.25), offset+(inner*2.25)));
    
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.12].CGColor);
    CGContextSetBlendMode(context, kCGBlendModeScreen);
    
    
    CGContextDrawPath(context, kCGPathEOFill);
    
    CGContextRestoreGState(context);
    
    image = BitmapImageCreateFromContext(context);
    
    CGContextRelease(context);
    
    return image;
}

- (NSString *)name {
    return @"Circle";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Circle"];
}

@end
