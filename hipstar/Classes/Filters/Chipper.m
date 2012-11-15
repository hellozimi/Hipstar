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
    
    GPUImagePicture *filterCompiler = [[GPUImagePicture alloc] initWithImage:image];
    
    GPUImageColorBalanceFilter *colorBalance = [[GPUImageColorBalanceFilter alloc] init];
    GPUVector3 midtones;
    midtones.one = 0.22;
    midtones.two = 0.0;
    midtones.three = 0.09;
    [colorBalance setMidtones:midtones];
    
    
    
    GPUImageHueFilter *hue = [[GPUImageHueFilter alloc] init];
    hue.hue = 0;
    
    
    GPUImageSaturationFilter *saturate = [[GPUImageSaturationFilter alloc] init];
    saturate.saturation = 0.8;
    
    [filterCompiler addTarget:colorBalance];
    [colorBalance addTarget:hue];
    [hue addTarget:saturate];
    
    [filterCompiler processImage];
    
    image = [colorBalance imageFromCurrentlyProcessedOutput];
    
    GPUImagePicture *overlay = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"radial_gradient_40"] smoothlyScaleOutput:YES];
    bottom = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageOverlayBlendFilter *gradientOverlay = [[GPUImageOverlayBlendFilter alloc] init];
    [bottom addTarget:gradientOverlay];
    [overlay addTarget:gradientOverlay];
    
    [bottom processImage];
    [overlay processImage];
    
    
    
    return [gradientOverlay imageFromCurrentlyProcessedOutput];
}

- (NSString *)name {
    return @"Chipper";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Chipper"];
}

@end
