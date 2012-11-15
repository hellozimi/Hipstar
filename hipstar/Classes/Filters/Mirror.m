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
    
    
    ///// FILTERING
    
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
    
    // Brightness
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc] init];
    brightness.brightness = 0.1;
    
    // Contrast
    GPUImageContrastFilter *contrast = [[GPUImageContrastFilter alloc] init];
    contrast.contrast = 1.2;
    
    // Saturation
    GPUImageSaturationFilter *saturation = [[GPUImageSaturationFilter alloc] init];
    saturation.saturation = 1.2;
    
    
    [picture addTarget:brightness];
    [brightness addTarget:contrast];
    [contrast addTarget:saturation];
    
    [picture processImage];
    
    UIImage *computedImage = [saturation imageFromCurrentlyProcessedOutput];
    
    
    CGContextTranslateCTM(context, rect.size.width, 0);
    CGContextScaleCTM(context, -1, 1);
    CGContextDrawImage(context, rect, computedImage.CGImage);
    
        
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
