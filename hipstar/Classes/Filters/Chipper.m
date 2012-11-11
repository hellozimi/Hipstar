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
    
    image = [curves imageByFilteringImage:image];
    
    return image;
}

- (NSString *)name {
    return @"Chipper";
}

@end
