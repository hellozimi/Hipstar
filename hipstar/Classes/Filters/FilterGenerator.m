//
//  FilterGenerator.m
//  hipstar
//
//  Created by Simon Andersson on 11/9/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "FilterGenerator.h"

#define SAFECOLOR(color) MIN(255,MAX(0,color))

@implementation FilterGenerator

CGContextRef BitmapContextCreateCopy(CGContextRef bitmapContext) {
    
    size_t width = CGBitmapContextGetWidth(bitmapContext);
    size_t height = CGBitmapContextGetHeight(bitmapContext);
    size_t bitsPerComponent = CGBitmapContextGetBitsPerComponent(bitmapContext);
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(bitmapContext);
    CGColorSpaceRef colorSpace = CGBitmapContextGetColorSpace(bitmapContext);
    
    size_t dataSize = bytesPerRow * height;
    
    unsigned char *data = CGBitmapContextGetData(bitmapContext);
    unsigned char *copyData;
    copyData = malloc(dataSize);
    memcpy(copyData, data, dataSize);
    
    CGBitmapInfo bitmapInfo = CGBitmapContextGetBitmapInfo(bitmapContext);
    
    CGContextRef context = CGBitmapContextCreate(copyData, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    return context;
}

CGContextRef BitmapContextCreateWithImage(UIImage *image, CGSize size) {
    
    float scale = [UIScreen mainScreen].scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGRect rect = CGRectMake(0, 0, size.width * scale, size.width * scale);
    
    CGContextRef context = CGBitmapContextCreate(nil, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake((image.size.height-image.size.width)/2, 0, image.size.width, image.size.height));
    
    
    CGContextDrawImage(context, rect, imageRef);
    CGImageRelease(imageRef);
    
    return context;
}

CGContextRef BitmapContextCreateWithSize(CGSize size) {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, (4 * size.width), colorSpace, kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

void BitmapContextComposite(CGContextRef baseContext, CGContextRef overlayContext, float alpha, CGBlendMode blendMode) {
    
    CGImageRef overlayContextImage = CGBitmapContextCreateImage(overlayContext);
    
    BitmapContextCompositeWithCGImage(baseContext, overlayContextImage, alpha, blendMode);
    
    CGImageRelease(overlayContextImage);
    
}

void BitmapContextCompositeImageNamed(CGContextRef context, NSString *imageName, float alpha, CGBlendMode blendMode) {
    CGImageRef image = [UIImage imageNamed:imageName].CGImage;
    
    BitmapContextCompositeWithCGImage(context, image, alpha, blendMode);
    
}


void BitmapContextCompositeWithCGImage(CGContextRef context, CGImageRef overlayImage, float alpha, CGBlendMode blendMode) {
    
    CGRect rect = CGRectMake(0, 0, CGBitmapContextGetWidth(context), CGBitmapContextGetHeight(context));
    
    CGContextSetBlendMode(context, blendMode);
    CGContextSetAlpha(context, alpha);
    CGContextDrawImage(context, rect, overlayImage);
    
}

UIImage *BitmapImageCreateFromContext(CGContextRef context) {
    
    CGImageRef img = CGBitmapContextCreateImage(context);
    
    UIImage *image = [UIImage imageWithCGImage:img];
    CGImageRelease(img);
    
    return image;
}

void BitmapContextRelease(CGContextRef context) {
    free(CGBitmapContextGetData(context));
}

CIImage *BitmapContextCreateCIImage(CGContextRef context);
CIImage *BitmapContextCreateCIImage(CGContextRef context) {
    CGImageRef image = CGBitmapContextCreateImage(context);
    CIImage *outputImage = [CIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    return outputImage;
}

@end
