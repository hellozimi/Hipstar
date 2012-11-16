//
//  Frapp.m
//  hipstar
//
//  Created by Simon Andersson on 11/15/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Frapp.h"

@implementation Frapp

- (UIImage *)apply:(UIImage *)image {
    
    /*
    GPUImageToneCurveFilter *curves = [[GPUImageToneCurveFilter alloc] init];
    
    [curves setRedControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, 0)],
     [NSValue valueWithCGPoint:CGPointMake(.345098039, .258823529)],
     [NSValue valueWithCGPoint:CGPointMake(.701960784, .756862745)],
     [NSValue valueWithCGPoint:CGPointMake(1, 1)],
     ]];
    
    [curves setGreenControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, 0)],
     [NSValue valueWithCGPoint:CGPointMake(.250980392, .17254902)],
     [NSValue valueWithCGPoint:CGPointMake(.670588235, .733333333)],
     [NSValue valueWithCGPoint:CGPointMake(1, 1)],
     ]];
    
    [curves setBlueControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, 0)],
     [NSValue valueWithCGPoint:CGPointMake(.615686275, .384313725)],
     [NSValue valueWithCGPoint:CGPointMake(1, .741176471)],
     ]];
    
    UIImage *outputImage = [curves imageByFilteringImage:image];
    
    GPUImageOpacityFilter *opacity = [[GPUImageOpacityFilter alloc] init];
    opacity.opacity = 0.75;
    UIImage *topImage = [opacity imageByFilteringImage:outputImage];
    
    GPUImageAlphaBlendFilter *alpha = [[GPUImageAlphaBlendFilter alloc] init];
    alpha.mix = 1.0;
    
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:image];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:topImage];
    
    [bottom addTarget:alpha];
    [top addTarget:alpha];
    
    [bottom processImage];
    [top processImage];
    
    
    image = [alpha imageFromCurrentlyProcessedOutput];
    
    
    GPUImageColorBalanceFilter *colorBalance = [[GPUImageColorBalanceFilter alloc] init];
    
    GPUVector3 vector;
    vector.three = 0.0;
    vector.two = 0.0;
    vector.one = 0.12;
    
    [colorBalance setShadows:vector];
    
    image = [colorBalance imageByFilteringImage:image];
    
    GPUImageGrayscaleFilter *grayscale = [[GPUImageGrayscaleFilter alloc] init];
    
    UIImage *grayedImage = [grayscale imageByFilteringImage:image];
    
    opacity = [[GPUImageOpacityFilter alloc] init];
    opacity.opacity = 0.15;
    
    grayedImage = [opacity imageByFilteringImage:grayedImage];
    
    alpha = [[GPUImageAlphaBlendFilter alloc] init];
    alpha.mix = 1.0;
    
    bottom = [[GPUImagePicture alloc] initWithImage:image];
    top = [[GPUImagePicture alloc] initWithImage:grayedImage];
    
    [bottom addTarget:alpha];
    [top addTarget:alpha];
    
    [bottom processImage];
    [top processImage];
    
    image = [alpha imageFromCurrentlyProcessedOutput];
    */
    return [self applyLookup:@"frappe_lookup_filter_1" image:image];
}

- (NSString *)name {
    return @"Frappe";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Frapp"];
}

@end
