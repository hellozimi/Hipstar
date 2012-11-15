//
//  Falling.m
//  hipstar
//
//  Created by Simon Andersson on 11/15/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Falling.h"

@implementation Falling

- (UIImage *)apply:(UIImage *)image {
    
    
    CGContextRef context = BitmapContextCreateWithImage(image, image.size);
    float scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0, 0, image.size.width*scale, image.size.height*scale);
    
    float offset = rect.size.width * 0.07;
    
    // 1
    CGContextSaveGState(context); {
        
        CGRect r = rect;
        
        CGContextAddEllipseInRect(context, r);
        CGContextClip(context);
        CGImageRef i = [self CGImageRotatedByAngle:image.CGImage angle:-10*1];
        CGContextDrawImage(context, r, i);
        CGImageRelease(i);
        
    } CGContextRestoreGState(context);
    
    // 2
    CGContextSaveGState(context); {
        
        CGRect r = CGRectInset(rect, offset, offset);
        
        CGContextAddEllipseInRect(context, r);
        CGContextClip(context);
        CGImageRef i = [self CGImageRotatedByAngle:image.CGImage angle:-10*2];
        CGContextDrawImage(context, r, i);
        CGImageRelease(i);
        
    } CGContextRestoreGState(context);
    
    
    // 3
    CGContextSaveGState(context); {
        
        CGRect r = CGRectInset(rect, offset*2, offset*2);
        
        CGContextAddEllipseInRect(context, r);
        CGContextClip(context);
        CGImageRef i = [self CGImageRotatedByAngle:image.CGImage angle:-10*3];
        CGContextDrawImage(context, r, i);
        CGImageRelease(i);
        
    } CGContextRestoreGState(context);
    
    
    // 4
    CGContextSaveGState(context); {
        
        CGRect r = CGRectInset(rect, offset*3, offset*3);
        
        CGContextAddEllipseInRect(context, r);
        CGContextClip(context);
        CGImageRef i = [self CGImageRotatedByAngle:image.CGImage angle:-10*4];
        CGContextDrawImage(context, r, i);
        CGImageRelease(i);
        
    } CGContextRestoreGState(context);
    
    
    // 5
    CGContextSaveGState(context); {
        
        CGRect r = CGRectInset(rect, offset*4, offset*4);
        
        CGContextAddEllipseInRect(context, r);
        CGContextClip(context);
        CGImageRef i = [self CGImageRotatedByAngle:image.CGImage angle:-10*5];
        CGContextDrawImage(context, r, i);
        CGImageRelease(i);
        
    } CGContextRestoreGState(context);
    
    image = BitmapImageCreateFromContext(context);
    
    CGContextRelease(context);
    
    
    return image;
}


- (CGImageRef)CGImageRotatedByAngle:(CGImageRef)imgRef angle:(CGFloat)angle
{
    CGFloat angleInRadians = angle * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, TRUE);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                          +(rotatedRect.size.width/2),
                          +(rotatedRect.size.height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                          -(rotatedRect.size.width/2),
                          -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                             rotatedRect.size.width,
                                             rotatedRect.size.height),
                       imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    
    return rotatedImage;
}

- (NSString *)name {
    return @"Falling";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"falling"];
}

@end
