//
//  Deck.m
//  hipstar
//
//  Created by Simon Andersson on 11/15/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Deck.h"

@implementation Deck

- (UIImage *)apply:(UIImage *)image {
    
    /*
    GPUImageToneCurveFilter *curves = [[GPUImageToneCurveFilter alloc] init];
    
    [curves setRedControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, .039215686)],
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
    
    
    GPUImagePicture *output = [[GPUImagePicture alloc] initWithImage:image];
    
    [output addTarget:curves];
    [output processImage];
    
    
    GPUImageGrayscaleFilter *grayscale = [[GPUImageGrayscaleFilter alloc] init];
    UIImage *grayscaleImage = [grayscale imageByFilteringImage:image];
    
    GPUImageOpacityFilter *opacity = [[GPUImageOpacityFilter alloc] init];
    opacity.opacity = 0.61;
    
    grayscaleImage = [opacity imageByFilteringImage:grayscaleImage];
    
    GPUImageAlphaBlendFilter *alpha = [[GPUImageAlphaBlendFilter alloc] init];
    alpha.mix = 1.0;
    
    GPUImagePicture *bottom = [[GPUImagePicture alloc] initWithImage:[curves imageFromCurrentlyProcessedOutput]];
    GPUImagePicture *top = [[GPUImagePicture alloc] initWithImage:grayscaleImage];
    
    [bottom addTarget:alpha];
    [top addTarget:alpha];
    
    [bottom processImage];
    [top processImage];
    
    UIImage *computed = [alpha imageFromCurrentlyProcessedOutput];
    
    
    curves = [[GPUImageToneCurveFilter alloc] init];
    
    [curves setBlueControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, 0)],
     [NSValue valueWithCGPoint:CGPointMake(.298039216, .188235294)],
     [NSValue valueWithCGPoint:CGPointMake(.545098039, .552941176)],
     [NSValue valueWithCGPoint:CGPointMake(1, 1)],
     ]];
    
    */
    return [self applyLookup:@"deck_lookup_filter_1" image:image];
}

- (NSString *)name {
    return @"Deck";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Deck"];
}

@end
