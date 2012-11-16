//
//  Frado.m
//  hipstar
//
//  Created by Simon Andersson on 11/15/12.
//  Copyright (c) 2012 hiddencode.me. All rights reserved.
//

#import "Frado.h"

@implementation Frado

- (UIImage *)apply:(UIImage *)image {
    
    /*
    
    GPUImageToneCurveFilter *curves = [[GPUImageToneCurveFilter alloc] init];
    
    [curves setRgbCompositeControlPoints:@[
     [NSValue valueWithCGPoint:CGPointMake(0, 0)],
     [NSValue valueWithCGPoint:CGPointMake(.360784314, .266666667)],
     [NSValue valueWithCGPoint:CGPointMake(.568627451, .6)],
     [NSValue valueWithCGPoint:CGPointMake(1, 1)],
     ]];
    
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
    
    */
    
    return [self applyLookup:@"frado_lookup_filter_1" image:image];
}

- (NSString *)name {
    return @"Frado";
}

- (UIImage *)image {
    return [UIImage imageNamed:@"Frado"];
}

@end
