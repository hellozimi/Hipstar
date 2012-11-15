//
//  Hexagon.m
//  hipstar
//
//  Created by Simon Andersson on 11/15/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Hexagon.h"

@implementation Hexagon


- (UIImage *)apply:(UIImage *)image {
    
    CGContextRef context = BitmapContextCreateWithImage(image, image.size);
    float scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
    
    float midx = CGRectGetMidX(rect);
    float midy = CGRectGetMidY(rect);
    CGPathRef path = PathCreateHexagonWithSize(CGPointMake(midx, midy), rect.size.width*0.4);
    
    // Draws EO hexagon
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.11].CGColor);
    CGContextSetBlendMode(context, kCGBlendModeScreen);
    CGContextDrawPath(context, kCGPathEOFill);
    CGContextRestoreGState(context);
    
    // Draws original image in hexagon
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRestoreGState(context);
    
    // Draws mirrored image in hexagon
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextSetAlpha(context, 0.3);
    CGContextDrawImage(context, rect, image.CGImage);
    CGContextRestoreGState(context);
    
    CGPathRelease(path);
    
    image = BitmapImageCreateFromContext(context);
    CGContextRelease(context);
    
    return image;
}

CGPathRef PathCreateHexagonWithSize(CGPoint center, float size) {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y + size);
    
    for(int i = 1; i < 6; ++i)
    {
        CGFloat x = size * sinf(i * 2.0 * M_PI / 6.0);
        
        CGFloat y = size * cosf(i * 2.0 * M_PI / 6.0);
        
        CGPathAddLineToPoint(path, NULL, center.x + x, center.y + y);
    }
    
    CGPathCloseSubpath(path);
    
    return path;
}

- (NSString *)name {
    return @"Hexagon";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Hexagon"];
}

@end
