//
//  Chipper.m
//  hipstar
//
//  Created by Simon Andersson on 11/11/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Chipper.h"

@implementation Chipper

- (UIImage *)apply:(UIImage *)image {
    
    GPUImageToneCurveFilter *curves = [[GPUImageToneCurveFilter alloc] init];
    [curves setRgbCompositeControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, 0)],
     [NSValue valueWithCGPoint:CGPointMake(.415686275, .290196078)],
     [NSValue valueWithCGPoint:CGPointMake(.568627451, .6)],
     [NSValue valueWithCGPoint:CGPointMake(1, 1)],
     ]];
    
    [curves setRedControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, .039215686)],
     [NSValue valueWithCGPoint:CGPointMake(.219607843, .298039216)],
     [NSValue valueWithCGPoint:CGPointMake(1, 1)],
     ]];
    
    [curves setGreenControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, .180392157)],
     [NSValue valueWithCGPoint:CGPointMake(1, .870588235)],
     ]];
    
    [curves setBlueControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, .415686275)],
     [NSValue valueWithCGPoint:CGPointMake(1, .678431373)],
     ]];
    
    UIImage *curveImage = [UIImage imageWithCGImage:image.CGImage];
    
    curveImage = [curves imageByFilteringImage:curveImage];
    
    GPUImageOpacityFilter *opacity = [[GPUImageOpacityFilter alloc] init];
    opacity.opacity = 0.35;
    
    curveImage = [opacity imageByFilteringImage:curveImage];
    
    
    GPUImageAlphaBlendFilter *alphaBlend = [[GPUImageAlphaBlendFilter alloc] init];
    alphaBlend.mix = 1.0;
    
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:image];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:curveImage];

    
    [bottom addTarget:alphaBlend];
    [top addTarget:alphaBlend];
    
    [bottom processImage];
    [top processImage];
    
    image = [alphaBlend imageFromCurrentlyProcessedOutput];
    
    GPUImageColorBalanceFilter *colorBalance = [[GPUImageColorBalanceFilter alloc] init];
    GPUVector3 midtones;
    midtones.one = 0.43;
    midtones.two = 0.0;
    midtones.three = 0.09;
    [colorBalance setMidtones:midtones];
    
    image = [colorBalance imageByFilteringImage:image];
    
    
    GPUImageHueFilter *hue = [[GPUImageHueFilter alloc] init];
    hue.hue = 3;
    
    image = [hue imageByFilteringImage:image];
    
    GPUImageSaturationFilter *saturate = [[GPUImageSaturationFilter alloc] init];
    saturate.saturation = 0.8;
    
    image = [saturate imageByFilteringImage:image];
    
    return image;
}

- (NSString *)name {
    return @"Chipper";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Chipper"];
}

@end
